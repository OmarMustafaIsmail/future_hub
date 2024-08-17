import 'package:future_hub/common/points/cubit/cubit.dart';
import 'package:future_hub/common/points/cubit/states.dart';
import 'package:future_hub/common/points/models/gift_brand.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/infinite_list_view.dart';
import 'package:future_hub/common/shared/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/palette.dart';
import '../widgets/points_partner_card.dart';

class PointPartnersScreen extends StatefulWidget {
  const PointPartnersScreen({super.key});

  @override
  State<PointPartnersScreen> createState() => _PointPartnersScreenState();
}

class _PointPartnersScreenState extends State<PointPartnersScreen> {
  Future<void> _onLoadMore() async {
    return BlocProvider.of<GiftsCubit>(context).loadBrands(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<GiftsCubit, GiftsState>(
      builder: (context, state) {
        if (state is GiftsBrandsLoadingState && state.isFirstFetch) {
          return const PaginatorLoadingIndicator();
        }
        List<GiftBrand> brands = [];
        bool canLoadMore = true;

        if (state is GiftsBrandsLoadingState) {
          brands = state.oldBrands;
        } else if (state is GiftsBrandsLoaded) {
          brands = state.brands;
          canLoadMore = state.canLoadMore;
        }

        return Scaffold(
          backgroundColor: Palette.whiteColor,
          appBar: FutureHubAppBar(
            title: Text(
              t.points_partners,
              style: const TextStyle(
                fontSize: 22,
                color: Palette.blackColor,
              ),
            ),
            context: context,
          ),
          body: state is GiftsBrandsLoadingState
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator.adaptive()),
                  ],
                )
              : InfiniteListView(
                  canLoadMore: canLoadMore,
                  onLoadMore: _onLoadMore,
                  itemBuilder: (_, index) => PointsPartnerCard(
                    brand: brands[index],
                  ),
                  itemCount: brands.length,
                ),
        );
      },
    );
  }
}
