
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:future_hub/common/auth/cubit/auth_cubit.dart';
import 'package:future_hub/common/auth/cubit/auth_state.dart';
import 'package:future_hub/common/auth/services/auth_service.dart';
import 'package:future_hub/common/graphql/schema.gql.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/utils/run_fetch.dart';
import 'package:future_hub/common/shared/widgets/clean_app_bar.dart';
import 'package:future_hub/common/shared/widgets/otp_form.dart';
import 'package:go_router/go_router.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({required this.phoneNumber, super.key});

  final String phoneNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _sendOTP());
  }

  Future<void> _sendOTP() async {
    await runFetch(
      context: context,
      fetch: () async {
        final authState = context.read<AuthCubit>().state as AuthSignedOut;
        await _authService.sendOTP(authState.phone, EnumVerifyEnum.Verify);
      },
    );
  }

  Future<String?> onActivate(String otp) async {
    String? error;

    await runFetch(
      context: context,
      fetch: () async {
        final authCubit = context.read<AuthCubit>();
        final authState = authCubit.state as AuthSignedOut;
        final user = await _authService.confirmOTP(
          authState.phone,
          otp,
          EnumVerifyEnum.Verify,
        );

        if (!mounted) return;

        authCubit.setOTP(otp);
        if (user != null) {
          authCubit.signingEmployee(user.name!, user.company_name!);
        }
        context.pushReplacement('/sign-up');
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

    return Scaffold(
      appBar: CleanAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t.enter_opt,
              style: theme.textTheme.headlineMedium!.copyWith(
                color: Palette.blackColor,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 24.0),
            BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              return OTPForm(
                buttonText: t.activate,
                phone: (state as AuthSignedOut).otp.isEmpty
                    ? widget.phoneNumber
                    : (state).otp,
                onActivate: onActivate,
              );
            }),
          ],
        ),
      ),
    );
  }
}
