import 'package:future_hub/common/shared/utils/run_fetch.dart';
import 'package:future_hub/common/shared/widgets/chevron_bottom_sheet.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/employee/orders/cubit/employee_punchers_cubit.dart';
import 'package:future_hub/employee/orders/cubit/order_cubit.dart';
import 'package:future_hub/employee/orders/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/shared/cubits/orders_cubit/orders_cubit.dart';
import '../../../common/shared/palette.dart';
import 'order_qr_code_bottom_sheet.dart';

class ActivateOrderBottomSheet extends StatefulWidget {
  const ActivateOrderBottomSheet({super.key});

  @override
  State<ActivateOrderBottomSheet> createState() =>
      _ActivateOrderBottomSheetState();
}

class _ActivateOrderBottomSheetState extends State<ActivateOrderBottomSheet> {
  final _orderService = OrderService();
  bool _loading = false;

  Future<void> _createOrder() async {
    final orderCubit = context.read<OrderCubit>();
    final state = orderCubit.state;

    await runFetch(
      context: context,
      fetch: () async {
        setState(() => _loading = true);

        final punchersCubit = context.read<EmployeePunchersCubit>();
        final branch = punchersCubit.cubitPunchers
            .firstWhere((b) => int.parse(b.id) == state.branchId);
        final order = await _orderService.createOrder(
          products: state.products.values.toList(),
          puncher: branch.puncher.id,
          branch: int.parse(branch.id),
          coupon: state.coupon,
        );

        orderCubit.orderCreated(order);

        if (!mounted) return;
        OrdersCubit.get(context).updatOrders();
        context.pop();

        showModalBottomSheet(
          context: context,
          builder: (context) => const OrderQrCodeBottomSheet(),
        );
      },
      after: () {
        setState(() => _loading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return ChevronBottomSheet(
      hasRadius: true,
      child: _loading
          ? const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 130,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Palette.textFeildBorder,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    t.do_you_want_to_activate,
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: Palette.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: SvgPicture.asset(
                    "assets/icons/timer.svg",
                    colorFilter: const ColorFilter.mode(
                        Palette.primaryColor, BlendMode.srcATop),
                    height: 35,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ChevronButton(
                    onPressed: _createOrder,
                    child: Text(t.activate),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width,
                  child: ChevronButton(
                    onPressed: () => Navigator.pop(context),
                    style: ChevronButtonStyle.disabled,
                    child: Text(t.not_now),
                  ),
                ),
              ],
            ),
    );
  }
}
