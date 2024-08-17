import 'package:equatable/equatable.dart';

class CompanyProduct {
  String id;
  String title;
  String? description;
  double price;
  double? discount;
  String? imagePath;
  double? companyPrice;
  Tax? tax;
  Unit? unit;
  List<Category>? categories;

  CompanyProduct(
      {required this.id,
      required this.title,
      required this.price,
      this.discount = 0,
      this.imagePath,
      this.description,
      this.tax,
      this.unit,
      this.companyPrice,
      this.categories});
}

class Tax {
  final String id;
  final String title;

  const Tax(this.id, this.title);
}

class Unit {
  final String id;
  final String title;

  Unit(this.id, this.title);
}

class Category extends Equatable {
  final String id;
  final String title;

  const Category({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];
}
