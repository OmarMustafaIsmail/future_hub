import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/common/shared/widgets/chevron_dashed_border.dart';
import 'package:future_hub/company/employees/cubit/employees_cubit.dart';
import 'package:future_hub/company/employees/cubit/employees_state.dart';
import 'package:future_hub/company/employees/widgets/add_employees_bottom_sheet.dart';
import 'package:future_hub/company/employees/widgets/employee_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CompanyEmployeesScreen extends StatelessWidget {
  const CompanyEmployeesScreen({super.key});

  void _addEmployee(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const AddEmployeesBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: FutureHubAppBar(
        title: Text(t.employees),
        context: context,
      ),
      body: BlocBuilder<EmployeesCubit, EmployeesState>(
        builder: (context, state) {
          if (state is EmployeesLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            t.employees,
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            '(${t.count_employees(state.employees.length)})',
                            style: theme.textTheme.titleMedium!
                                .copyWith(color: Palette.greyColor.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      ChevronDashedBorder(
                        child: ChevronButton(
                          onPressed: () => _addEmployee(context),
                          style: ChevronButtonStyle.dashed(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/add.svg'),
                              const SizedBox(width: 8.0),
                              Text(t.add_an_employee),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: state.employees.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: EmployeeListItem(
                          employee: state.employees[index],
                          onPressed: () {
                            context.push(
                              '/company/employee/${state.employees[index].id}',
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          // TODO: handle loading and failure states
          return Container();
        },
      ),
    );
  }
}
