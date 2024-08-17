import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/services/orders_services.dart';
import 'package:future_hub/common/shared/utils/run_fetch.dart';
import 'package:future_hub/common/shared/widgets/chevron_bottom_sheet.dart';
import 'package:future_hub/puncher/shared/widgets/otp_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

enum OrderDoneState {
  confirm,
  cancel,
}

class OrderDoneBottomSheet extends StatefulWidget {
  final String referenceNumber;

  const OrderDoneBottomSheet({super.key, required this.referenceNumber});

  @override
  State<OrderDoneBottomSheet> createState() => _OrderDoneBottomSheetState();
}

class _OrderDoneBottomSheetState extends State<OrderDoneBottomSheet> {
  final _ordersService = OrdersService();

  void _otpBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => VerifyOtpBottomSheet(
        referenceNumber: widget.referenceNumber,
      ),
    );
  }

  bool isButtonEnabled = true;

  Future<void> _confirm() async {
    if (isButtonEnabled) {
      // يُعين الزرار على "معطل" لمدة 10 ثوانٍ.
      setState(() {
        isButtonEnabled = false;
      });
      await runFetch(
        context: context,
        fetch: () async {
          await _ordersService.sendOtp(widget.referenceNumber);
          _otpBottomSheet();
        },
        after: () {
          // setState(() => _loading = false);
        },
      );

      // بعد انتهاء المهلة (10 ثوانٍ)، قم بتمكين الزرار مرة أخرى.
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            isButtonEnabled = true;
          });
        }
      });
    }
  }

  Future<void> _cancel() async {
    await runFetch(
      context: context,
      fetch: () async {
        await _ordersService.cancelOrder(widget.referenceNumber);

        if (!mounted) return;

        context.go('/puncher');
        // TODO: show success message here
      },
      after: () {
        // setState(() => _loading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ChevronBottomSheet(
      hasRadius: true,
      child: Column(
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
            height: 30,
          ),
          Text(
            t.finish_the_order,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge!
                .copyWith(color: Palette.primaryColor),
          ),
          const SizedBox(height: 35.0),
          GestureDetector(
            onTap: () => _confirm,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/client-recieved-order.png',
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  t.client_recieved_the_products,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Palette.dividerColor,
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () => _cancel,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/products-not-available.png',
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  t.products_arent_available,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Palette.dividerColor,
          ),
          // ChevronButton(
          //   disabled: _loading,
          //   style: ChevronButtonStyle.dashed(
          //     color: isButtonEnabled ? Palette.primaryColor : Colors.grey,
          //     filled: true,
          //   ),
          //   onPressed: _confirm,
          //   child: Text(t.confirm_order),
          // ),
          // const SizedBox(height: 8.0),
          // ChevronButton(
          //   disabled: _loading,
          //   style: ChevronButtonStyle.dashed(
          //     color: Palette.greyColor.shade600,
          //     filled: false,
          //   ),
          //   onPressed: _cancel,
          //   child: Text(t.products_arent_available),
          // ),
        ],
      ),
    );
  }
}
