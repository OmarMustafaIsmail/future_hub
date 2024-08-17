import 'package:future_hub/common/shared/utils/validator.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/common/shared/widgets/chevron_labled_text_field.dart';
import 'package:future_hub/company/employees/cubit/employees_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddSingleEmployee extends StatefulWidget {
  const AddSingleEmployee({super.key});

  @override
  State<AddSingleEmployee> createState() => _AddSingleEmployeeState();
}

class _AddSingleEmployeeState extends State<AddSingleEmployee> {
  bool _loading = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _limitController = TextEditingController(text: '0');
  final _form = GlobalKey<FormState>();
  Map<String, String> _validation = {};

  Future<void> _addEmployee() async {
    if (!_form.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    await context.read<EmployeesCubit>().addEmployee(
          context: context,
          name: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          idNumber: _idNumberController.text,
          limit: _limitController.text.isNotEmpty
              ? double.parse(_limitController.text)
              : null,
          onValidation: (validation) {
            _validation = validation;
            _form.currentState!.validate();
          },
        );

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: FutureHubAppBar(
        title: Text(t.add_an_employee),
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
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ChevronLabeledTextField(
                          controller: _nameController,
                          label: t.employee_name,
                          hintText: t.enter_employee_name_here,
                          icon: SvgPicture.asset('assets/icons/person.svg'),
                          keyboardType: TextInputType.name,
                          onChanged: (value) =>
                              _validation.remove('input.name'),
                          validator: (value) {
                            return Validator(value)
                                .custom((value) => _validation['input.name'])
                                .mandatory(t.this_field_is_required)
                                .alpha(t.name_must_contain_only_letters)
                                .error;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        ChevronLabeledTextField(
                          controller: _phoneController,
                          label: t.phone_number,
                          hintText: t.enter_phone_number_05XXXXXXXX,
                          icon: SvgPicture.asset('assets/icons/phone.svg'),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) =>
                              _validation.remove('input.mobile'),
                          validator: (value) {
                            return Validator(value)
                                .custom((value) => _validation['input.mobile'])
                                .mandatory(t.this_field_is_required)
                                .digits(t.phone_number_must_contain_only_digits)
                                .startsWith(
                                    '05', t.phone_number_must_start_with_05)
                                .length(10, t.phone_number_must_be_10_digits)
                                .error;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        ChevronLabeledTextField(
                          controller: _emailController,
                          label: t.email,
                          hintText: t.enter_email_here,
                          icon: SvgPicture.asset('assets/icons/email.svg'),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) =>
                              _validation.remove('input.email'),
                          validator: (value) {
                            return Validator(value)
                                .custom((value) => _validation['input.email'])
                                .mandatory(t.this_field_is_required)
                                .email(t.please_enter_a_valid_email)
                                .error;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        ChevronLabeledTextField(
                          controller: _idNumberController,
                          label: t.id_number,
                          hintText: t.enter_id_number_here,
                          icon: SvgPicture.asset('assets/icons/id.svg'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              _validation.remove('input.national_id'),
                          validator: (value) {
                            return Validator(value)
                                .custom(
                                    (value) => _validation['input.national_id'])
                                .mandatory(t.this_field_is_required)
                                .digits(t.id_number_must_contain_only_digits)
                                .length(10, t.id_number_must_be_10_digits)
                                .error;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        ChevronLabeledTextField(
                          controller: _limitController,
                          label: t.limit,
                          hintText: t.enter_the_limit_here,
                          icon: SvgPicture.asset('assets/icons/wallet.svg'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              _validation.remove('input.wallet_limit'),
                          validator: (value) {
                            return Validator(value)
                                .custom((value) =>
                                    _validation['input.wallet_limit'])
                                .number(t.limit_must_be_a_valid_number)
                                .error;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        const Spacer(),
                        ChevronButton(
                          onPressed: _addEmployee,
                          loading: _loading,
                          child: Text(t.add),
                        ),
                      ],
                    ),
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
