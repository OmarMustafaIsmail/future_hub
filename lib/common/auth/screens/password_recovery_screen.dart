
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:future_hub/common/auth/cubit/auth_cubit.dart';
import 'package:future_hub/common/auth/cubit/auth_state.dart';
import 'package:future_hub/common/auth/widgets/password_text_field.dart';
import 'package:future_hub/common/graphql/schema.gql.dart';
import 'package:future_hub/common/shared/utils/validator.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';

import '../../shared/palette.dart';
import '../../shared/utils/run_fetch.dart';
import '../services/auth_service.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  bool _loading = false;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Map<String, String> _validation = {};

  final _authService = AuthService();

  void _changePassword() async {
    if (!_form.currentState!.validate()) return;

    runFetch(
      context: context,
      fetch: () async {
        setState(() {
          _loading = true;
        });
        final state = context.read<AuthCubit>().state as AuthSignedOut;
        final result = await _authService.resetPassword(
          phone: state.phone,
          otp: state.otp,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          type: EnumVerifyEnum.Reset,
        );

        if (!mounted) return;

        final authCubit = context.read<AuthCubit>();

        await authCubit.login(result.user, result.token);
      },
      after: () {
        setState(() {
          _loading = false;
        });
      },
      onValidation: (validation) {
        _validation = validation;
        _form.currentState!.validate();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: FutureHubAppBar(
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t.password_recovery,
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: Palette.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              PasswordTextField(
                controller: _passwordController,
                labelText: t.new_password,
                hintText: t.enter_new_password_here,
                onChanged: (value) => _validation.remove('input.password'),
                validator: (value) {
                  return Validator(value)
                      .custom((value) => _validation['input.password'])
                      .mandatory(t.this_field_is_required)
                      .min(8, t.password_must_have_8_characters_or_more)
                      .error;
                },
              ),
              const SizedBox(height: 24.0),
              PasswordTextField(
                controller: _confirmPasswordController,
                labelText: t.confirm_new_password,
                hintText: t.enter_new_password_again,
                onChanged: (value) =>
                    _validation.remove('input.password_confirmation'),
                validator: (value) {
                  final password = _passwordController.text;
                  return Validator(value)
                      .custom(
                          (value) => _validation['input.password_confirmation'])
                      .mandatory(t.this_field_is_required)
                      .equal(password,
                          t.password_confirmation_doesnt_match_password)
                      .error;
                },
              ),
              const SizedBox(height: 24.0),
              const Spacer(),
              ChevronButton(
                loading: _loading,
                onPressed: _changePassword,
                child: Text(t.change_password),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
