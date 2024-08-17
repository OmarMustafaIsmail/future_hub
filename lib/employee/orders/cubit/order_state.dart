import 'package:future_hub/common/auth/cubit/auth_cubit.dart';
import 'package:future_hub/common/auth/cubit/auth_state.dart';
import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/employee/orders/cubit/employee_punchers_cubit.dart';
import 'package:future_hub/employee/orders/models/order_product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class OrderState extends Equatable {
  double totalPrice;
  double? totalVat;
  double? totalDiscount;
  final int totalQuantity;
  final Map<String, OrderProduct> products;
  final int? branchId;
  final String? coupon;

  OrderState({
    required this.products,
    double? totalPrice,
    int? totalQuantity,
    this.branchId,
    this.coupon,
    this.totalDiscount,
    this.totalVat,
  })  : totalPrice = totalPrice ?? _computeTotalPrice(products.values),
        totalQuantity = totalQuantity ?? _computeTotalQuantity(products.values);

  static double _computeTotalPrice(Iterable<OrderProduct> products) {
    if (products.isEmpty) return 0;

    return products
        .map((product) => product.quantity.toDouble() * product.product.price)
        .reduce((total, current) => total + current);
  }

  static int _computeTotalQuantity(Iterable<OrderProduct> products) {
    if (products.isEmpty) return 0;

    return products
        .map((product) => product.quantity)
        .reduce((total, current) => total + current);
  }

  OrderState withCoupon(String coupon) {
    return OrderState(
      products: products,
      totalPrice: totalPrice,
      totalQuantity: totalQuantity,
      coupon: coupon,
      branchId: branchId,
    );
  }

  OrderState withPuncher(int puncher) {
    return OrderState(
      products: products,
      totalPrice: totalPrice,
      totalQuantity: totalQuantity,
      coupon: coupon,
      branchId: puncher,
    );
  }

  OrderState copyWith({
    Map<String, OrderProduct>? products,
    double? totalPrice,
    int? totalQuantity,
    int? branchId,
    String? coupon,
    double? totalVat,
    double? totalDiscount,
  }) {
    return OrderState(
        products: products ?? this.products,
        totalPrice: totalPrice ?? this.totalPrice,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        branchId: branchId ?? this.branchId,
        coupon: coupon ?? this.coupon,
        totalDiscount: totalDiscount,
        totalVat: totalVat);
  }

  @override
  List<Object?> get props => [
        totalPrice,
        totalQuantity,
        products,
        coupon,
        branchId,
      ];

  Order toOrder(BuildContext context) {
    final orderProducts = products.values
        .map(
          (product) => OrderProducts(
            id: int.parse(product.product.id),
            product: product.product,
            quantity: product.quantity,
            unitPrice: product.product.price,
            totalPrice: product.quantity * product.product.price,
          ),
        )
        .toList();

    final punchersCubit = context.read<EmployeePunchersCubit>();
    final branch = punchersCubit.cubitPunchers
        .firstWhere((p) => int.parse(p.id) == branchId);
    final authState = context.read<AuthCubit>().state as AuthSignedIn;
    final user = authState.user;
    return Order(
      coupon: Coupon(code: coupon),
      puncher: branch.puncher,
      totalPrice: totalPrice,
      products: orderProducts,
      vatValue: totalVat,
      discount: totalDiscount,
      discountValue: totalDiscount,
      user: user,
    );
  }
}

//ignore: must_be_immutable

//ignore: must_be_immutable
class OrderCreatedState extends OrderState {
  final String referenceNumber;

  OrderCreatedState(
      {required this.referenceNumber,
      required super.products,
      super.totalPrice,
      super.totalQuantity,
      super.branchId,
      super.coupon,
      super.totalVat,
      super.totalDiscount});

  factory OrderCreatedState.fromOrder(
    OrderState order, {
    required String referenceNumber,
  }) {
    return OrderCreatedState(
        referenceNumber: referenceNumber,
        products: order.products,
        totalPrice: order.totalPrice,
        totalQuantity: order.totalQuantity,
        branchId: order.branchId,
        coupon: order.coupon,
        totalVat: order.totalVat,
        totalDiscount: order.totalDiscount);
  }
}
