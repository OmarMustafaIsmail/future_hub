import 'package:future_hub/common/auth/cubit/auth_cubit.dart';
import 'package:future_hub/common/auth/cubit/auth_state.dart';
import 'package:future_hub/common/shared/cubits/orders_cubit/orders_cubit.dart';
import 'package:future_hub/common/shared/cubits/orders_cubit/orders_states.dart';
import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/labeled_icon_placeholder.dart';
import 'package:future_hub/common/shared/widgets/infinite_list_view.dart';
import 'package:future_hub/common/shared/widgets/loading_indicator.dart';
import 'package:future_hub/common/shared/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/wallet/widgets/balance_card.dart';

class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({
    super.key,
    required this.onTapBalance,
  });

  final void Function() onTapBalance;

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  Future<void> _onLoadMore() async {
    return BlocProvider.of<OrdersCubit>(context).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final paddingTop = MediaQuery.of(context).padding.top;
    final appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              height: 1.75 * appBarHeight + paddingTop,
              child: FutureHubAppBar(
                title: Text(t.home),
                context: context,
              ),
            ),
            Positioned.fill(
              top: paddingTop + appBarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: GestureDetector(
                      onTap: widget.onTapBalance,
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return BalanceCard(
                            balance:
                                (state as AuthSignedIn).user.wallet.toString(),
                            onDeposit: () =>
                                context.push('/payment-methods-screen'),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 18.0,
                    ),
                    child: Text(
                      t.previous_orders,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<OrdersCubit, OrderStates>(
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

                        return InfiniteListView(
                          canLoadMore: canLoadMore,
                          onLoadMore: _onLoadMore,
                          padding: EdgeInsets.zero,
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: GestureDetector(
                                onTap: () => context.push(
                                  '/employee/order-details',
                                  extra: orders[index],
                                ),
                                child: OrderCard(
                                  order: orders[index],
                                ),
                              ),
                            );
                          },
                          empty: LabeledIconPlaceholder(
                            icon:
                                SvgPicture.asset('assets/icons/no-orders.svg'),
                            label: t.there_are_no_orders,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
