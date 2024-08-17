import 'package:future_hub/common/shared/cubits/products_cubit/products_states.dart';
import 'package:future_hub/common/shared/utils/run_fetch.dart';
import 'package:future_hub/common/shared/widgets/flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/products.dart';
import '../../services/products_services.dart';

class ProductsCubit extends Cubit<ProductsStates> {
  ProductsCubit() : super(CompanyProductsInitState());

  static ProductsCubit get(context) => BlocProvider.of(context);

  int page = 1;

  final _productsService = ProductsService();

  List<CompanyProduct> companyProducts = [];

  Future<void> loadProducts(context, {bool refresh = false}) async {
    if (state is CompanyProductsLoadingState) return;
    final currentState = state;
    var oldProducts = <CompanyProduct>[];
    var total = 0;
    if (currentState is CompanyProductsLoadedState) {
      oldProducts = currentState.products;
      total = currentState.total;
    }
    if (refresh) {
      page = 1;
      oldProducts = [];
    }
    emit(
      CompanyProductsLoadingState(
        oldProducts,
        isFirstFetch: page == 1,
        total: total,
      ),
    );
    var newProducts = await _productsService.fetchProducts(page);
    page++;
    final products = (state as CompanyProductsLoadingState).oldProducts;
    products.addAll(newProducts.data);
    companyProducts = products;
    for (var product in companyProducts) {
      for (var cat in product.categories!) {
        categories.add(cat);
      }
    }

    debugPrint(categories.length.toString());
    emit(
      CompanyProductsLoadedState(
        products: products,
        canLoadMore: newProducts.hasMorePages,
        total: newProducts.total,
      ),
    );
  }

  Future<void> updateProduct({
    required double price,
    required String productId,
    required BuildContext context,
  }) async {
    final bool canLoadMore = state is! CompanyProductsLoadedState ||
        (state as CompanyProductsLoadedState).canLoadMore;
    final int total = (state is CompanyProductsLoadedState)
        ? (state as CompanyProductsLoadedState).total
        : (state as CompanyProductsLoadingState).total;

    emit(UpdateProductLoadingState());
    await runFetch(
      context: context,
      fetch: () async {
        await _productsService.updateProduct(
          price: price,
          productId: productId,
        );
      },
    );

    companyProducts
        .firstWhere((product) => product.id == productId)
        .companyPrice = price;

    emit(
      CompanyProductsLoadedState(
        products: companyProducts,
        canLoadMore: canLoadMore,
        total: total,
      ),
    );

    if (context.mounted) {
      final t = AppLocalizations.of(context)!;
      showToast(
          text: t.product_updated_successfully, state: ToastStates.success);
    }
  }

  Set<Category> categories = {};

  int categoryIndex = 0;

  changeCategory(int index) {
    categoryIndex = index;
  }
}
