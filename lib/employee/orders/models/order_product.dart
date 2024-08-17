import 'package:future_hub/common/shared/models/products.dart';

class OrderProduct {
  final int quantity;
  final CompanyProduct product;

  const OrderProduct({
    required this.product,
    required this.quantity,
  });

  OrderProduct withQuantity(int quantity) {
    return OrderProduct(
      product: product,
      quantity: quantity,
    );
  }
}
