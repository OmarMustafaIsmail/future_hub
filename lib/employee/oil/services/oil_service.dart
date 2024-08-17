import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/employee/oil/models/car_brand.dart';
import 'package:future_hub/employee/oil/graphql/oil.gql.dart';
import 'package:future_hub/employee/oil/models/car_model.dart';
import 'package:future_hub/employee/oil/models/car_year.dart';
import '../../../common/shared/utils/paginator_info.dart';

class OilService {
  Future<List<CarBrand>> getCarBrands() async {
    final result = await Client.current.queryCarBrands();

    final brands = result.parsedData!.car_brands;

    return brands
        .map(
          (brand) => CarBrand(
            id: int.parse(brand.id),
            imageURL: brand.image_path,
            title: brand.title,
          ),
        )
        .toList();
  }

  Future<List<CarModel>> getCarModels({required int brand}) async {
    final result = await Client.current.queryCarModels(
      OptionsQueryCarModels(
        variables: VariablesQueryCarModels(
          brandId: brand,
        ),
      ),
    );

    final brands = result.parsedData!.car_models;

    return brands
        .map(
          (brand) => CarModel(
            id: int.parse(brand.id),
            title: brand.title,
          ),
        )
        .toList();
  }

  Future<List<CarYear>> getCarYears() async {
    final result = await Client.current.queryCarYears();

    final brands = result.parsedData!.car_years;

    return brands
        .map(
          (brand) => CarYear(
            id: int.parse(brand.id),
            title: brand.title,
          ),
        )
        .toList();
  }

  Future<PaginatorInfo<QueryCarOilscar_oilsdata>> getBestOils(
      {required int page,
      required int carModelId,
      required int brandModelId,
      required int yearModelId}) async {
    final result = await Client.current.queryCarOils(
      OptionsQueryCarOils(
        variables: VariablesQueryCarOils(
          brandId: [brandModelId],
          carModelId: [carModelId],
          carYearId: [yearModelId],
          page: page,
        ),
      ),
    );

    final data = result.parsedData?.car_oils;
    final hasMorePages = data!.paginatorInfo.hasMorePages;

    return PaginatorInfo(data: data.data, hasMorePages: hasMorePages);
  }
}
