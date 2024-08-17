import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/points/graphql/points.gql.dart';
import 'package:future_hub/common/points/models/gift_brand.dart';
import 'package:future_hub/common/points/models/user_gift.dart';
import 'package:future_hub/common/shared/utils/fetch_exception.dart';
import 'package:future_hub/common/shared/utils/paginator_info.dart';
import 'package:flutter/material.dart';

class PointsService {
  Future<int> scanProductCode(String referenceNumber) async {
    final result = await Client.current.mutateScanProductPointsCode(
      OptionsMutationScanProductPointsCode(
        variables: VariablesMutationScanProductPointsCode(
          referenceNumber: referenceNumber,
        ),
      ),
    );
    final data = result.parsedData?.scanQrCodeProduct;
    final status = data?.status;
    final message = data?.message;
    final points = data?.data?.points;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);

    return points!;
  }

  Future<UserGift> createUserCoupon({required int points}) async {
    final result = await Client.current.mutateCreateUserCoupon(
      OptionsMutationCreateUserCoupon(
        variables: VariablesMutationCreateUserCoupon(points: points),
      ),
    );

    final data = result.parsedData?.createUserCoupon;
    final status = data?.status;
    final message = data?.message;
    final giftData = data?.data;
    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);

    return UserGift(
        id: giftData!.id ?? "",
        youGotAGift: giftData.yougotagift_id!,
        youGotAGiftStatus: giftData.yougotagift_status!,
        barcode: giftData.barcode!,
        referenceNumber: giftData.reference_number!,
        expiryDate: giftData.expiry_date!,
        giftVoucherLabel: giftData.gift_voucher_label!,
        redemptionInstructions: giftData.redemption_instructions!,
        giftCardPin: giftData.egift_card_gift_verification_pin!,
        giftVoucherValue: giftData.gift_voucher_value!,
        amount: giftData.amount!,
        points: giftData.points!);
  }

  Future<PaginatorInfo<GiftBrand>> getYouGotAGiftBrands(
      {required int page}) async {
    final result = await Client.current.queryGiftBrand(
      OptionsQueryGiftBrand(
        variables: VariablesQueryGiftBrand(page: page),
      ),
    );
    final numberPointsResult = await Client.current.queryNumberPoints();
    final numberPoints = numberPointsResult.parsedData?.aboutUs.number_point;

    final data = result.parsedData?.giftBrands!.data;
    final hasMorePages =
        result.parsedData?.giftBrands!.paginatorInfo!.hasMorePages;
    return PaginatorInfo(
      data: data!
          .map(
            (e) => GiftBrand(
              id: e!.id ?? 0,
              brandCode: e.brand_code!,
              logo: e.logo!,
              name: e.name!,
              productImage: e.product_image!,
              description: e.description!,
              denominations: e.denominations!.SAR!
                  .map(
                    (den) => Denominations(
                      amount: den!.amount,
                      isActive: den.is_active ?? false,
                      points: den.amount != null
                          ? den.amount! * numberPoints!
                          : null,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
      hasMorePages: hasMorePages!,
    );
  }

  Future<PaginatorInfo<UserGift>> fetchPreviousGifts(int page) async {
    final result = await Client.current.queryPreviousGifts(
      OptionsQueryPreviousGifts(
        variables: VariablesQueryPreviousGifts(page: page),
      ),
    );
    final data = result.parsedData?.gifts;
    final gifts = data!.data;
    final hasMorePages = data.paginatorInfo.hasMorePages;
    final total = data.paginatorInfo.total;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    return PaginatorInfo(
      data: gifts
          .map((gift) => UserGift(
              id: gift.id ?? "",
              youGotAGift: gift.yougotagift_id!,
              youGotAGiftStatus: gift.yougotagift_status!,
              barcode: gift.barcode!,
              referenceNumber: gift.reference_number!,
              expiryDate: gift.expiry_date!,
              giftVoucherLabel: gift.gift_voucher_label!,
              redemptionInstructions: gift.redemption_instructions!,
              giftCardPin: gift.egift_card_gift_verification_pin!,
              giftVoucherValue: gift.gift_voucher_value!,
              points: gift.points!,
              amount: gift.amount!))
          .toList(),
      hasMorePages: hasMorePages,
      total: total,
    );
  }
}
