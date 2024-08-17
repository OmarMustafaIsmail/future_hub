import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/services/orders_services.dart';
import 'package:future_hub/common/shared/widgets/infinite_list_view.dart';
import 'package:future_hub/common/shared/widgets/labeled_icon_placeholder.dart';
import 'package:future_hub/common/shared/widgets/loading_indicator.dart';
import 'package:future_hub/common/shared/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class EmployeeOrdersListView extends StatefulWidget {
  final int id;

  const EmployeeOrdersListView({
    super.key,
    required this.id,
  });

  @override
  State<EmployeeOrdersListView> createState() => _EmployeeOrdersListViewState();
}

class _EmployeeOrdersListViewState extends State<EmployeeOrdersListView> {
  final _ordersService = OrdersService();
  final _orders = <Order>[];
  var _isFirstFetch = true;
  var _isLoading = false;
  var _canLoadMore = true;
  var _page = 0;

  Future<void> _onLoadMore() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final orders = await _ordersService.fetchOrders(
      page: _page,
      employee: widget.id,
      cache: true,
    );

    setState(() {
      _orders.addAll(orders.data);
      _canLoadMore = orders.hasMorePages;
      _page++;
      _isLoading = false;
      _isFirstFetch = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return _isFirstFetch
        ? const PaginatorLoadingIndicator()
        : InfiniteListView(
            padding: const EdgeInsets.only(
              right: 24.0,
              left: 24.0,
              bottom: 24.0,
            ),
            itemCount: _orders.length,
            onLoadMore: _onLoadMore,
            canLoadMore: _canLoadMore,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: () => context.push(
                    '/employee/order-details',
                    extra: _orders[index],
                  ),
                  child: OrderCard(
                    order: _orders[index],
                  ),
                ),
              );
            },
            empty: LabeledIconPlaceholder(
              icon: SvgPicture.asset('assets/icons/no-orders.svg'),
              label: t.there_are_no_orders,
            ),
          );
  }
}
