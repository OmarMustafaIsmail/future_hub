import 'package:future_hub/common/shared/cubits/orders_cubit/orders_cubit.dart';
import 'package:future_hub/common/shared/cubits/orders_cubit/orders_states.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/labeled_icon_placeholder.dart';
import 'package:future_hub/common/shared/widgets/infinite_list_view.dart';
import 'package:future_hub/common/shared/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/common/shared/widgets/order_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/shared/models/order_model.dart';

class EmployeeOrdersScreen extends StatefulWidget {
  const EmployeeOrdersScreen({super.key});

  @override
  State<EmployeeOrdersScreen> createState() => _EmployeeOrdersScreenState();
}

class _EmployeeOrdersScreenState extends State<EmployeeOrdersScreen> {
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
            title: Text(t.my_orders),
            context: context,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(24.0),
              //   child: Text(
              //     t.my_orders,
              //     style: theme.textTheme.titleLarge,
              //   ),
              // ),
              Expanded(
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: InfiniteListView(
                        canLoadMore: canLoadMore,
                        onLoadMore: _onLoadMore,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: index == orders.length - 1 ? 80 : 16.0,
                                left: 24.0,
                                right: 24.0),
                            child: GestureDetector(
                                onTap: () => context.push(
                                      '/employee/order-details',
                                      extra: orders[index],
                                    ),
                                child: OrderCard(
                                  showUser: false,
                                  order: orders[index],
                                )),
                          );
                        },
                        empty: LabeledIconPlaceholder(
                          icon: SvgPicture.asset('assets/icons/no-orders.svg'),
                          label: t.there_are_no_orders,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 30,
                      right: 30,
                      child: ChevronButton(
                        onPressed: () => context.push('/employee/new-order'),
                        child: Text(t.new_order),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
