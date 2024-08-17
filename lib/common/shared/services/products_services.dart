import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/graphql/products/products.gql.dart';
import 'package:future_hub/common/shared/utils/paginator_info.dart';
import 'package:future_hub/common/shared/models/products.dart';
import 'package:flutter/material.dart';

import '../utils/fetch_exception.dart';

class ProductsService {
  Future<PaginatorInfo<CompanyProduct>> fetchProducts(int page) async {
    final result = await Client.current.queryProducts(
      OptionsQueryProducts(
        variables: VariablesQueryProducts(page: page),
      ),
    );
    final data = result.parsedData?.products;
    final products = data!.data;
    final hasMorePages = data.paginatorInfo.hasMorePages;
    final total = data.paginatorInfo.total;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    return PaginatorInfo(
      data: products
          .map(
            (product) => CompanyProduct(
                id: product.id,
                title: product.title!,
                price: product.price!,
                discount: product.discount,
                imagePath: product.image_path,
                description: product.description!,
                tax: Tax(product.tax!.id, product.tax!.title),
                unit: Unit(product.unit!.id, product.unit!.title),
                companyPrice: product.company_price,
                categories: product.categories!
                    .map((category) =>
                        Category(id: category!.id, title: category.title))
                    .toList()),
          )
          .toList(),
      hasMorePages: hasMorePages,
      total: total,
    );
  }

  Future<PaginatorInfo<Category>> fetchCategories(int page) async {
    final result = await Client.current.queryCategories(
      OptionsQueryCategories(
        variables: VariablesQueryCategories(page: page),
      ),
    );
    final data = result.parsedData?.categories;
    final categories = data!.data;
    final hasMorePages = data.paginatorInfo.hasMorePages;
    final total = data.paginatorInfo.total;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    return PaginatorInfo(
      data: categories
          .map((product) => Category(
                id: product.id,
                title: product.title,
              ))
          .toList(),
      hasMorePages: hasMorePages,
      total: total,
    );
  }

  Future<void> updateProduct(
      {required double price, required String productId}) async {
    final result = await Client.current.mutateUpdateProduct(
      OptionsMutationUpdateProduct(
        variables:
            VariablesMutationUpdateProduct(price: price, product_id: productId),
      ),
    );

    final data = result.parsedData?.updateProduct;
    final status = data?.status;
    final message = data?.message;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);
  }
}
