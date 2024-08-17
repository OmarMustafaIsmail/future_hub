import 'package:future_hub/common/shared/cubits/orders_cubit/orders_cubit.dart';
import 'package:future_hub/common/shared/cubits/orders_cubit/orders_states.dart';
import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/infinite_list_view.dart';
import 'package:future_hub/common/shared/widgets/loading_indicator.dart';
import 'package:future_hub/puncher/components/past_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class PuncherOrdersListView extends StatefulWidget {
  const PuncherOrdersListView({super.key});

  @override
  State<PuncherOrdersListView> createState() => _PuncherOrdersListViewState();
}

class _PuncherOrdersListViewState extends State<PuncherOrdersListView> {
  Future<void> _onLoadMore() async {
    return BlocProvider.of<OrdersCubit>(context).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<OrdersCubit, OrderStates>(
      builder: (context, state) {
        if (state is OrdersLoadingState && state.isFirstFetch) {
          return const PaginatorLoadingIndicator();
        }
        List<Order> orders = [];
        bool canLoadMore = true;
        if (state is OrdersLoadingState) {
          orders = state.oldOrders;
        } else if (state is OrdersLoadedState) {
          orders = state.orders;
          canLoadMore = state.canLoadMore;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        t.orders,
                        style:
                            theme.textTheme.titleLarge!.copyWith(fontSize: 26),
                      ),
                      Text(
                        " (${t.count_orders(orders.length)})",
                        style:  const TextStyle(
                          fontSize: 15,
                          color: Palette.primaryLightColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: InfiniteListView(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      canLoadMore: canLoadMore,
                      onLoadMore: _onLoadMore,
                      empty: Column(
                        children: [
                          Image.asset(
                            'assets/images/empty.png',
                            height: MediaQuery.of(context).size.height * 0.25,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            t.the_place_here_is_empty,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            t.you_can_find_your_orders_here,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Palette.textGreyColor,
                            ),
                          )
                        ],
                      ),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == orders.length - 1 ? 80 : 16.0,
                            left: 24.0,
                            right: 24.0,
                          ),
                          child: GestureDetector(
                              onTap: () => context.push(
                                    '/employee/order-details',
                                    extra: orders[index],
                                  ),
                              child: PastOrderCard(
                                order: orders[index],
                                isLast: orders.last == orders[index],
                              )),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
