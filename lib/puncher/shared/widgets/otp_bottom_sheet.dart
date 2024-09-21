import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_hub/common/shared/cubits/orders_cubit/orders_cubit.dart';
import 'package:future_hub/common/shared/services/orders_services.dart';
import 'package:future_hub/common/shared/utils/run_fetch.dart';
import 'package:future_hub/common/shared/widgets/chevron_bottom_sheet.dart';
import 'package:future_hub/common/shared/widgets/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpBottomSheet extends StatefulWidget {
  const VerifyOtpBottomSheet({required this.referenceNumber, super.key});
  final String referenceNumber;

  @override
  State<VerifyOtpBottomSheet> createState() => VerifyOtpBottomSheetState();
}

class VerifyOtpBottomSheetState extends State<VerifyOtpBottomSheet> {
  final _ordersService = OrdersService();

  Future<void> _resend() async {
    await _ordersService.sendOtp(
      widget.referenceNumber,
    );
  }

  bool _loading = false;

  Future<String?> _onActivate(String otp) async {
    String? error;
    await runFetch(
      context: context,
      fetch: () async {
        setState(() {
          _loading = true;
        });

        await _ordersService.confirmOrder(otp, widget.referenceNumber);

        if (!mounted) return;

        context.pop();
        context.pop();
        context.pop();
      },
      after: () async {
        print("d5lna hna");
        BlocProvider.of<OrdersCubit>(context).loadOrders(refresh: true);
        print("tl3nna hna");
        setState(() {
          _loading = false;
        });
      },
      onValidation: (validation) {
        error = validation['input.code'];
      },
    );

    return error;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ChevronBottomSheet(
        child: SizedBox(
          height: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t.enter_the_code_sent_to_employee_number,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 18.0),
              OTPForm(
                loading: _loading,
                phone: "",
                onActivate: _onActivate,
                onResend: _resend,
                buttonText: t.confirm_order,
              )
            ],
          ),
        ),
      ),
    );
  }
}
