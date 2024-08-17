import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/graphql/orders/orders.gql.dart';
import 'package:future_hub/common/graphql/schema.gql.dart';
import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/utils/fetch_exception.dart';
import 'package:future_hub/employee/orders/graphql/order.gql.dart';
import 'package:future_hub/employee/orders/models/order_product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class OrderService {
  Future<Order> createOrder({
    required int puncher,
    required int branch,
    required List<OrderProduct> products,
    String? coupon,
  }) async {
    final orderProducts = products
        .map(
          (product) => InputProductItem(
            quantity: product.quantity,
            product_id: int.parse(product.product.id),
          ),
        )
        .toList();

    final result = await Client.current.mutateCreateOrder(
      OptionsMutationCreateOrder(
        variables: VariablesMutationCreateOrder(
          puncher: puncher,
          branch: branch,
          coupon: coupon,
          products: orderProducts,
        ),
      ),
    );

    final data = result.parsedData?.createOrder;
    final referenceNumber = data?.reference_number;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    debugPrint(referenceNumber);

    return Order(
        referenceNumber: referenceNumber!,
        totalPrice: data!.total_price,
        vatValue: data.vat_value,
        discountValue: data.discount_value);
  }

  Future<dynamic> validateCoupon({
    required int puncher,
    required List<OrderProduct> products,
    String? coupon,
  }) async {
    final orderProducts = products
        .map(
          (product) => InputProductItem(
            quantity: product.quantity,
            product_id: int.parse(product.product.id),
          ),
        )
        .toList();

    final result = await Client.current.mutateValidateCoupon(
      OptionsMutationValidateCoupon(
        variables: VariablesMutationValidateCoupon(
          puncherId: puncher,
          coupon: coupon,
          products: orderProducts,
        ),
      ),
    );

    debugPrint(result.toString());
    if (result.hasException) {
      debugPrint(result.exception!.graphqlErrors[0].message.toString());
      return result.exception!.graphqlErrors[0].message.toString();
    }

    final data = result.parsedData?.validateCoupon;
    final details = data!.data;
    debugPrint(data.message);
    debugPrint(details!.vat_value.toString());
    debugPrint(details.total_price.toString());
    debugPrint(details.discount.toString());

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }
    return Order(
      totalPrice: details.total_price,
      discount: details.discount,
      vatValue: details.vat_value,
      vat: details.vat,
      discountValue: details.discount_value,
    );
  }
}
