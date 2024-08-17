import 'package:future_hub/common/shared/models/products.dart';
import 'package:future_hub/employee/oil/cubit/best_oil_cubit/best_oil_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/oil_service.dart';

class ProductsCubit extends Cubit<BestOilsState> {
  ProductsCubit() : super(BestOilsInitState());

  static ProductsCubit get(context) => BlocProvider.of(context);

  int page = 1;

  final _oilsService = OilService();

  Map<String, List<CompanyProduct>> oils = {
    'Coolants': [],
    'Differential': [],
    'DifferentialFront': [],
    'Engine': [],
    'PowerSteering': [],
    'TransferBox': [],
    'AutomaticTransmission': [],
    'ManualTransmission': [],
  };

  Future<void> loadProducts(
      context, int brandModel, int carModel, int yearModel) async {
    if (state is BestOilsLoadingState) return;

    final currentState = state;

    Map<String, List<CompanyProduct>> oldOils = oils;
    if (currentState is BestOilsLoadedState) {
      oldOils = currentState.oils;
    }

    emit(
      BestOilsLoadingState(
        oldOils,
        isFirstFetch: false,
      ),
    );
    var newOils = await _oilsService.getBestOils(
        page: page,
        carModelId: carModel,
        brandModelId: brandModel,
        yearModelId: yearModel);
    page++;
    final products = (state as BestOilsLoadingState).oldOils;
    products['Coolants'] = newOils.data[0].oil_products!.oilCoolants!
        .map(
          (e) => CompanyProduct(
            id: e.id,
            title: e.title ?? "",
            price: e.price ?? 0,
            imagePath: e.image_path,
            description: e.description,
          ),
        )
        .toList();
    products['Differential'] = newOils.data[0].oil_products!.oilDifferential!
        .map(
          (e) => CompanyProduct(
            id: e.id,
            title: e.title ?? "",
            price: e.price ?? 0,
            imagePath: e.image_path,
            description: e.description,
          ),
        )
        .toList();
    products['DifferentialFront'] =
        newOils.data[0].oil_products!.oilDifferentialFront!
            .map(
              (e) => CompanyProduct(
                id: e.id,
                title: e.title ?? "",
                price: e.price ?? 0,
                imagePath: e.image_path,
                description: e.description,
              ),
            )
            .toList();
    products['Engine'] = newOils.data[0].oil_products!.oilEngine!
        .map(
          (e) => CompanyProduct(
            id: e.id,
            title: e.title ?? "",
            price: e.price ?? 0,
            imagePath: e.image_path,
            description: e.description,
          ),
        )
        .toList();
    products['PowerSteering'] = newOils.data[0].oil_products!.oilPowerSteering!
        .map(
          (e) => CompanyProduct(
            id: e.id,
            title: e.title ?? "",
            price: e.price ?? 0,
            imagePath: e.image_path,
            description: e.description,
          ),
        )
        .toList();
    products['TransferBox'] = newOils.data[0].oil_products!.oilTransferBox!
        .map(
          (e) => CompanyProduct(
            id: e.id,
            title: e.title ?? "",
            price: e.price ?? 0,
            imagePath: e.image_path,
            description: e.description,
          ),
        )
        .toList();
    products['AutomaticTransmission'] =
        newOils.data[0].oil_products!.oilAutomaticTransmission!
            .map(
              (e) => CompanyProduct(
                id: e.id,
                title: e.title ?? "",
                price: e.price ?? 0,
                imagePath: e.image_path,
                description: e.description,
              ),
            )
            .toList();
    products['ManualTransmission'] =
        newOils.data[0].oil_products!.oilManualTransmission!
            .map(
              (e) => CompanyProduct(
                id: e.id,
                title: e.title ?? "",
                price: e.price ?? 0,
                imagePath: e.image_path,
                description: e.description,
              ),
            )
            .toList();
    emit(
      BestOilsLoadedState(
        oils: products,
        canLoadMore: newOils.hasMorePages,
      ),
    );
  }
}
