import 'package:future_hub/common/shared/cubits/orders_cubit/orders_cubit.dart';
import 'package:future_hub/common/shared/cubits/orders_cubit/orders_states.dart';
import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/infinite_list_view.dart';
import 'package:future_hub/common/shared/widgets/loading_indicator.dart';

import 'package:future_hub/puncher/components/past_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class PuncherOrdersScreen extends StatefulWidget {
  const PuncherOrdersScreen({super.key});

  @override
  State<PuncherOrdersScreen> createState() => _PuncherOrdersScreenState();
}

class _PuncherOrdersScreenState extends State<PuncherOrdersScreen> {
  Future<void> _onLoadMore() async {
    return BlocProvider.of<OrdersCubit>(context).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

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
        return Scaffold(
          appBar: FutureHubAppBar(
            title: Text(
              t.orders,
              style: const TextStyle(
                  color: Palette.blackColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            context: context,
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InfiniteListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    canLoadMore: canLoadMore,
                    onLoadMore: _onLoadMore,
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
                  ),
                ),
                // PreferredSize(
                //   preferredSize: const Size(200, 200),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(50),
                //     child: Theme(
                //       data: ThemeData(
                //         textTheme: GoogleFonts.almaraiTextTheme(),
                //         dividerColor: Colors.transparent,
                //         splashColor: Colors.transparent,
                //         highlightColor: Colors.transparent,
                //       ),
                //       child: Material(
                //         color: Palette.tabBarColor,
                //         child: TabBar(
                //           indicatorPadding: const EdgeInsets.symmetric(
                //               horizontal: 5, vertical: 3),
                //           overlayColor: WidgetStateProperty.all<Color>(
                //             Colors.transparent,
                //           ),
                //           unselectedLabelStyle:
                //               theme.textTheme.displaySmall!.copyWith(
                //             fontSize: 20,
                //             fontWeight: FontWeight.normal,
                //           ),
                //           dividerColor: Colors.transparent,
                //           unselectedLabelColor:
                //               Palette.textGreyColor.withOpacity(0.5),
                //           indicatorSize: TabBarIndicatorSize.tab,
                //           labelColor: Colors.white,
                //           indicatorColor: Colors.black,
                //           labelPadding: EdgeInsets.symmetric(
                //               vertical:
                //                   MediaQuery.of(context).size.height * 0.007),
                //           indicator: BoxDecoration(
                //             borderRadius: BorderRadius.circular(50),
                //             color: Palette.primaryColor,
                //           ),
                //           tabs: [
                //             Tab(
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(50),
                //                 ),
                //                 child: Align(
                //                     alignment: Alignment.center,
                //                     child: Text(
                //                       t.current,
                //                       style: const TextStyle(
                //                         fontSize: 21,
                //                         fontWeight: FontWeight.bold,
                //                       ),
                //                     )),
                //               ),
                //             ),
                //             Tab(
                //               child: Align(
                //                 child: Text(
                //                   t.finished,
                //                   style: const TextStyle(
                //                     fontSize: 21,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: TabBarView(
                //     children: [
                //       SizedBox(
                //         width: double.infinity,
                //         child: InfiniteListView(
                //           padding: const EdgeInsets.symmetric(
                //             vertical: 10,
                //           ),
                //           canLoadMore: canLoadMore,
                //           onLoadMore: _onLoadMore,
                //           itemCount: orders.any((order) => order.status! == 1)
                //               ? orders
                //                   .where((order) => order.status! != 1)
                //                   .toList()
                //                   .length
                //               : 0,
                //           itemBuilder: (context, index) {
                //             return Padding(
                //               padding: EdgeInsets.only(
                //                 bottom:
                //                     index == orders.length - 1 ? 80 : 16.0,
                //                 left: 24.0,
                //                 right: 24.0,
                //               ),
                //               child: GestureDetector(
                //                   onTap: () => context.push(
                //                         '/employee/order-details',
                //                         extra: orders[index],
                //                       ),
                //                   child: PastOrderCard(
                //                     order: orders
                //                         .where((order) => order.status! == 1)
                //                         .toList()[index],
                //                     isLast: orders.last == orders[index],
                //                   )),
                //             );
                //           },
                //         ),
                //       ),
                //       SizedBox(
                //         width: double.infinity,
                //         child: InfiniteListView(
                //           padding: const EdgeInsets.symmetric(
                //             vertical: 10,
                //           ),
                //           canLoadMore: canLoadMore,
                //           onLoadMore: _onLoadMore,
                //           itemCount: orders.any((order) => order.status! != 1)
                //               ? orders
                //                   .where((order) => order.status! != 1)
                //                   .toList()
                //                   .length
                //               : 0,
                //           itemBuilder: (context, index) {
                //             return Padding(
                //               padding: EdgeInsets.only(
                //                 bottom:
                //                     index == orders.length - 1 ? 80 : 16.0,
                //                 left: 24.0,
                //                 right: 24.0,
                //               ),
                //               child: GestureDetector(
                //                   onTap: () => context.push(
                //                         '/employee/order-details',
                //                         extra: orders[index],
                //                       ),
                //                   child: PastOrderCard(
                //                     order: orders
                //                         .where((order) => order.status! != 1)
                //                         .toList()[index],
                //                     isLast: orders.last == orders[index],
                //                   )),
                //             );
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
