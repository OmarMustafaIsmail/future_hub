import 'dart:async';

import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/common/shared/widgets/infinite_list_view.dart';
import 'package:future_hub/common/shared/widgets/order_card_item.dart';
import 'package:future_hub/common/shared/widgets/price_text.dart';
import 'package:future_hub/employee/components/best_car_oil_widget.dart';
import 'package:future_hub/employee/orders/cubit/order_cubit.dart';
import 'package:future_hub/employee/orders/cubit/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../common/shared/cubits/products_cubit/products_cubit.dart';
import '../../../common/shared/cubits/products_cubit/products_states.dart';
import '../../../common/shared/models/products.dart';
import '../../../common/shared/widgets/loading_indicator.dart';

class EmployeePuncherScreen extends StatefulWidget {
  const EmployeePuncherScreen(this.id, {required this.name, super.key});

  final int id;
  final String name;

  @override
  State<EmployeePuncherScreen> createState() => _EmployeePuncherScreenState();
}

class _EmployeePuncherScreenState extends State<EmployeePuncherScreen> {
  var loading = false;

  Future<void> _loadOrder() async {
    setState(() {
      loading = true;
    });
    context.read<OrderCubit>().validateOrder(context).whenComplete(() {
      setState(() {
        loading = false;
      });
      context.push(
        '/employee/order-details?showButton=true',
        extra: context.read<OrderCubit>().state.toOrder(context),
      );
    });
  }

  Future<void> _onLoadMore() async {
    return BlocProvider.of<ProductsCubit>(context).loadProducts(context);
  }

  @override
  void initState() {
    super.initState();
    final orderCubit = context.read<OrderCubit>();
    orderCubit.choosePuncher(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return BlocConsumer<ProductsCubit, ProductsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CompanyProductsLoadingState && state.isFirstFetch) {
          return const PaginatorLoadingIndicator();
        }
        List<CompanyProduct> products = [];
        bool canLoadMore = true;
        if (state is CompanyProductsLoadingState) {
          products = state.oldProducts;
        } else if (state is CompanyProductsLoadedState) {
          products = state.products;
          canLoadMore = state.canLoadMore;
        }

        return Scaffold(
          backgroundColor: Palette.whiteColor,
          appBar: FutureHubAppBar(
            title: Text(
              widget.name,
              style: const TextStyle(
                fontSize: 22,
                color: Palette.blackColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            isCart: true,
            context: context,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BestCarOilCard(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    t.choose_product,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                // SizedBox(
                //   width: size.width,
                //   height: 40,
                //   child: ListView.builder(
                //     clipBehavior: Clip.none,
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (context, index) {
                //       return CategoryChip(
                //         title: cubit.categories.elementAt(index).title,
                //         selected: cubit.categoryIndex == index,
                //       );
                //     },
                //     itemCount: cubit.categories.length,
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: InfiniteListView(
                      itemCount: products.length,
                      canLoadMore: canLoadMore,
                      onLoadMore: _onLoadMore,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 20),
                          child: InkWell(
                            onTap: () {
                              context.push(
                                '/company/product/${products[index].id}?company=false',
                                extra: products[index],
                              );
                            },
                            child: OrderCardItem(
                              showQuantity: false,
                              showPrice: true,
                              product: OrderProducts(
                                  id: int.parse(products[index].id.toString()),
                                  product: products[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomSheet: SizedBox(
            height: size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Palette.primaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: BlocBuilder<OrderCubit, OrderState>(
                        builder: (context, state) {
                          return Text(
                            state.totalQuantity.toString(),
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.order_total,
                        style: theme.textTheme.titleMedium!.copyWith(
                            color: Palette.primaryColor,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<OrderCubit, OrderState>(
                          builder: (context, state) {
                        return PriceText(price: state.totalPrice);
                      }),
                    ],
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 3,
                    child: BlocBuilder<OrderCubit, OrderState>(
                      builder: (context, state) {
                        return ChevronButton(
                          loading: loading,
                          onPressed: _loadOrder,
                          child: Text(t.next),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
