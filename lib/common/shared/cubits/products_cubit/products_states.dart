import 'package:future_hub/common/shared/models/products.dart';

abstract class ProductsStates {}

class CompanyProductsInitState extends ProductsStates {}

class CompanyProductsLoadedState extends ProductsStates {
  final bool canLoadMore;
  final List<CompanyProduct> products;
  final int total;
  CompanyProductsLoadedState({
    required this.products,
    required this.canLoadMore,
    required this.total,
  });
}

class CompanyProductsLoadingState extends ProductsStates {
  final List<CompanyProduct> oldProducts;
  final bool isFirstFetch;
  final int total;

  CompanyProductsLoadingState(
    this.oldProducts, {
    this.isFirstFetch = false,
    required this.total,
  });
}

class UpdateProductLoadingState extends ProductsStates {}
