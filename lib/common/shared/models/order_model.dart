import 'package:future_hub/common/shared/models/products.dart';
import 'package:future_hub/employee/orders/models/puncher.dart';
import 'package:equatable/equatable.dart';

import '../../auth/models/user.dart';

class Order extends Equatable {
  final String? id;
  final User? user;
  final String? referenceNumber;
  final double? price;
  final double? totalPrice;
  final double? discount;
  final double? discountValue;
  final double? vat;
  final double? vatValue;
  final Coupon? coupon;
  final Puncher? puncher;
  final Company? company;
  final int? status;
  final String? name;
  final String? createdAt;
  final List<OrderProducts>? products;

  const Order(
      {this.id,
      this.user,
      this.price,
      this.discount,
      this.discountValue,
      this.referenceNumber,
      this.totalPrice,
      this.vat,
      this.vatValue,
      this.coupon,
      this.puncher,
      this.company,
      this.createdAt,
      this.name,
      this.status,
      this.products});

  @override
  List<Object?> get props => [
        id,
        user,
        price,
        discount,
        discountValue,
        referenceNumber,
        totalPrice,
        vat,
        vatValue,
        coupon,
        company,
        puncher,
        createdAt,
        products
      ];

  Order copyWith(
      {String? id,
      User? user,
      String? referenceNumber,
      double? price,
      double? totalPrice,
      double? discount,
      double? discountValue,
      double? vat,
      double? vatValue,
      Coupon? coupon,
      Puncher? puncher,
      Company? company,
      int? status,
      String? name,
      String? createdAt,
      List<OrderProducts>? products}) {
    return Order(
        id: id ?? this.id,
        user: user ?? this.user,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        price: price ?? this.price,
        totalPrice: totalPrice ?? this.totalPrice,
        discount: discount ?? this.discount,
        discountValue: discountValue ?? this.discountValue,
        vat: vat ?? this.vat,
        vatValue: vatValue ?? this.vatValue,
        coupon: coupon ?? this.coupon,
        puncher: puncher ?? this.puncher,
        company: company ?? this.company,
        status: status ?? this.status,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        products: products ?? this.products);
  }
}

class Coupon {
  final String? id;
  final String? title;
  final String? code;
  final double? discount;
  final int? discountType;
  final String? startDate;
  final String? expireDate;

  Coupon(
      {this.id,
      this.title,
      this.code,
      this.discount,
      this.discountType,
      this.expireDate,
      this.startDate});
}

class Company {
  final String? id;
  final String? name;
  final String? code;

  Company({this.id, this.name, this.code});
}

class OrderProducts {
  final int? id;
  final CompanyProduct? product;
  final int? quantity;
  final double? unitPrice;
  final double? totalPrice;
  final double? discount;
  final double? discountValue;

  OrderProducts(
      {this.id,
      this.product,
      this.quantity,
      this.totalPrice,
      this.unitPrice,
      this.discount,
      this.discountValue});
}
