import 'package:future_hub/common/auth/models/user.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/common/shared/widgets/chevron_labled_text_field.dart';
import 'package:future_hub/company/employees/cubit/employees_cubit.dart';
import 'package:future_hub/company/employees/cubit/employees_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditEmployeeScreen extends StatefulWidget {
  const EditEmployeeScreen({
    required this.employee,
    super.key,
  });

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
  final User employee;
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  bool _loading = false;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _idNumberController;
  late TextEditingController _limitController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.employee.name);
    _phoneController = TextEditingController(text: widget.employee.phone);
    _emailController = TextEditingController(text: widget.employee.email);
    _idNumberController =
        TextEditingController(text: widget.employee.nationalId);
    _limitController =
        TextEditingController(text: widget.employee.limit.toString());
    debugPrint(_phoneController.text);
    debugPrint(_limitController.text);
  }

  Future<void> _updateEmployee() async {
    setState(() {
      _loading = true;
    });

    await context.read<EmployeesCubit>().updateEmployee(
        context: context,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        id: int.parse(widget.employee.id!),
        nationalId: _idNumberController.text,
        limit: _limitController.text);

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocConsumer<EmployeesCubit, EmployeesState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: FutureHubAppBar(
              title: Text(t.edit_employee),
              context: context,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10.0),
                      Center(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Palette.greyColor.shade300,
                          backgroundImage: widget.employee.imageURL != null
                              ? NetworkImage(widget.employee.imageURL!)
                              : null,
                        ),
                      ),
                      ChevronLabeledTextField(
                        controller: _nameController,
                        label: t.username,
                        hintText: t.username,
                        icon: SvgPicture.asset('assets/icons/person.svg'),
                      ),
                      const SizedBox(height: 20.0),
                      ChevronLabeledTextField(
                        controller: _phoneController,
                        label: t.phone_number,
                        hintText: t.phone_number,
                        icon: SvgPicture.asset('assets/icons/phone.svg'),
                      ),
                      const SizedBox(height: 20.0),
                      ChevronLabeledTextField(
                        controller: _emailController,
                        label: t.email,
                        hintText: t.email,
                        icon: SvgPicture.asset('assets/icons/email.svg'),
                      ),
                      const SizedBox(height: 20.0),
                      ChevronLabeledTextField(
                        controller: _idNumberController,
                        label: t.id_number,
                        hintText: t.enter_id_number_here,
                        icon: SvgPicture.asset('assets/icons/id.svg'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20.0),
                      ChevronLabeledTextField(
                        controller: _limitController,
                        label: t.limit,
                        hintText: t.enter_the_limit_here,
                        icon: SvgPicture.asset('assets/icons/wallet.svg'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ChevronButton(
                        onPressed: _updateEmployee,
                        loading: _loading,
                        child: Text(t.save_changes),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
