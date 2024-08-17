import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/common/shared/widgets/chevron_card.dart';
import 'package:future_hub/common/shared/widgets/order_card.dart';
import 'package:future_hub/puncher/shared/widgets/order_done_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PuncherOrderDetailsScreen extends StatelessWidget {
  static const orderDoneStatus = 1;
  final showUser = false;
  final Order order;

  const PuncherOrderDetailsScreen({required this.order, super.key});

  void _orderDone(BuildContext context) {
    if (order.referenceNumber == null) return;
    showModalBottomSheet(
      context: context,
      builder: (context) => OrderDoneBottomSheet(
        referenceNumber: order.referenceNumber!,
      ),
    );
  }
  // 0547247342
  // 0562396700

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: FutureHubAppBar(
        title: Text(t.order_details),
        context: context,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OrderCard(
                        showPrices: false,
                        showUser: false,
                        summary: false,
                        showTotal: false,
                        showQuantity: true,
                        order: order,
                      ),
                      const SizedBox(height: 16.0),
                      if (showUser)
                        ChevronCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.client_name,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 12.0),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            order.user!.imageURL ??
                                                'https://unsplash.it/100/100'),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        order.user!.name ?? "",
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.company_name,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 12.0),
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          'https://cdn.mos.cms.futurecdn.net/tQxVwcJSowYD7xwWDYidd9.jpg',
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        order.company!.name ?? "",
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16.0),
                      const Spacer(),
                      if (order.status != orderDoneStatus)
                        ChevronButton(
                          onPressed: () => _orderDone(context),
                          child: Text(t.order_has_been_done),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
