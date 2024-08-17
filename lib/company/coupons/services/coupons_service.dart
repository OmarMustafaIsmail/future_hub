import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/utils/fetch_exception.dart';
import 'package:future_hub/common/shared/utils/paginator_info.dart';
import 'package:future_hub/company/coupons/graphql/coupons.gql.dart';

class CouponsService {
  Future<PaginatorInfo<Coupon>> fetchCoupons(int page) async {
    final result = await Client.current.queryCoupons(
      OptionsQueryCoupons(
        variables: VariablesQueryCoupons(page: page),
      ),
    );

    final data = result.parsedData?.coupons;
    final coupons = data!.data;
    final hasMorePages = data.paginatorInfo.hasMorePages;
    final total = data.paginatorInfo.total;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }
    return PaginatorInfo(
        data: coupons
            .map(
              (coupon) => Coupon(
                id: coupon.id,
                title: coupon.title,
                code: coupon.code,
                discount: coupon.discount,
                discountType: coupon.discount_type,
                startDate: coupon.start_at,
                expireDate: coupon.expire_at,
              ),
            )
            .toList(),
        hasMorePages: hasMorePages,
        total: total);
  }
}
