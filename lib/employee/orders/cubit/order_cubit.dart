import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/models/products.dart';
import 'package:future_hub/employee/orders/cubit/employee_punchers_cubit.dart';
import 'package:future_hub/employee/orders/cubit/order_state.dart';
import 'package:future_hub/employee/orders/models/order_product.dart';
import 'package:future_hub/employee/orders/services/order_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit()
      : super(
          OrderState(
            products: const {},
            totalPrice: 0,
            totalQuantity: 0,
          ),
        );

  void addProduct(CompanyProduct product) {
    if (state.products.containsKey(product.id)) return;

    final orderProduct = OrderProduct(
      product: product,
      quantity: 1,
    );

    emit(
      state.copyWith(
        products: {
          ...state.products,
          orderProduct.product.id: orderProduct,
        },
        totalPrice: state.totalPrice + product.price,
        totalQuantity: state.totalQuantity + 1,
      ),
    );
  }

  void removeProduct(String id, {bool isFinal = false}) {
    if (!state.products.containsKey(id)) return;

    final product = state.products[id]!;
    final remaining = Map.fromEntries(
      state.products.entries.where((entry) => entry.key != id),
    );

    emit(
      state.copyWith(
        products: remaining,
        totalPrice: state.totalPrice - product.quantity * product.product.price,
        totalQuantity: state.totalQuantity - product.quantity,
      ),
    );
  }

  void changeProductQuantity(String id, int quantity) {
    if (!state.products.containsKey(id)) return;

    final product = state.products[id]!;
    final totalQuantity = state.totalQuantity + quantity - product.quantity;
    final priceDifference =
        (quantity - product.quantity) * product.product.price;
    final totalPrice = state.totalPrice + priceDifference;
    final updated = state.products.map(
      (productId, product) => productId == id
          ? MapEntry(productId, product.withQuantity(quantity))
          : MapEntry(productId, product),
    );

    emit(
      state.copyWith(
        products: updated,
        totalPrice: totalPrice,
        totalQuantity: totalQuantity,
      ),
    );
  }

  void incrementProductQuantity(String id) {
    if (!state.products.containsKey(id)) return;

    final quantity = state.products[id]!.quantity + 1;
    changeProductQuantity(id, quantity);
  }

  void decrementProductQuantity(String id) {
    if (!state.products.containsKey(id)) return;

    final quantity = state.products[id]!.quantity - 1;
    if (quantity == 0) {
      removeProduct(id);
    } else {
      changeProductQuantity(id, quantity);
    }
  }

  void choosePuncher(int puncher) {
    emit(state.copyWith(branchId: puncher));
  }

  void orderCreated(Order order) {
    emit(
      OrderCreatedState.fromOrder(
        state.copyWith(
          totalPrice: order.totalPrice,
          totalVat: order.vatValue,
          totalDiscount: order.discountValue,
        ),
        referenceNumber: order.referenceNumber!,
      ),
    );
  }

  final _orderService = OrderService();

  Future validateOrder(BuildContext context, {String? coupon}) async {
    final punchersCubit = context.read<EmployeePunchersCubit>();
    final branch = punchersCubit.cubitPunchers
        .firstWhere((p) => int.parse(p.id) == state.branchId);
    var newData = await _orderService.validateCoupon(
      puncher: branch.puncher.id,
      products: state.products.values.toList(),
      coupon: coupon,
    );
    if (newData.runtimeType == String) {
      return newData;
    }
    state.totalPrice = newData.totalPrice!;
    state.totalVat = newData.vatValue!;
    state.totalDiscount = newData.discount!;
    emit(state.copyWith(
      coupon: coupon,
      products: state.products,
      branchId: state.branchId,
      totalDiscount: state.totalDiscount,
      totalVat: state.totalVat,
      totalPrice: state.totalPrice,
      totalQuantity: state.totalQuantity,
    ));
  }
}
