import 'package:future_hub/common/graphql/schema.gql.dart';
import 'package:future_hub/common/shared/utils/run_fetch.dart';
import 'package:future_hub/common/shared/widgets/flutter_toast.dart';
import 'package:future_hub/company/employees/cubit/employees_state.dart';
import 'package:future_hub/company/employees/services/employees_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit() : super(EmployeesLoading());

  static EmployeesCubit get(context) => BlocProvider.of(context);

  final _employeesService = EmployeesService();

  Future<void> init() async {
    try {
      final result = await _employeesService.getEmployees();

      emit(EmployeesLoaded(result.data));
    } catch (error) {
      emit(EmployeesLoadFailed());
    }
  }

  Future<void> stopEmployee({
    required String id,
    required BuildContext context,
  }) async {
    if (state is! EmployeesLoaded) return;

    await runFetch(
      context: context,
      fetch: () async {
        await _employeesService.stopEmployee(id: int.parse(id));

        final employees = (state as EmployeesLoaded).employees;
        final updated = employees
            .map(
              (employee) => employee.id == id
                  ? employee.copyWith(active: false)
                  : employee,
            )
            .toList();

        emit(EmployeesLoaded(updated));

        if (context.mounted) {
          final t = AppLocalizations.of(context)!;
          showToast(
              text: t.employee_stopped_successfully,
              state: ToastStates.success);
        }
      },
    );
  }

  Future<void> activateEmployee({
    required String id,
    required BuildContext context,
  }) async {
    if (state is! EmployeesLoaded) return;

    await runFetch(
      context: context,
      fetch: () async {
        await _employeesService.activateEmployee(id: int.parse(id));

        final employees = (state as EmployeesLoaded).employees;
        final updated = employees
            .map(
              (employee) => employee.id == id
                  ? employee.copyWith(active: true)
                  : employee,
            )
            .toList();

        emit(EmployeesLoaded(updated));

        if (context.mounted) {
          final t = AppLocalizations.of(context)!;
          showToast(
              text: t.employee_activated_successfully,
              state: ToastStates.success);
        }
      },
    );
  }

  Future<void> deleteEmployee({
    required String id,
    required BuildContext context,
  }) async {
    if (state is! EmployeesLoaded) return;

    await runFetch(
      context: context,
      fetch: () async {
        await _employeesService.deleteEmployee(id: int.parse(id));

        final employees = (state as EmployeesLoaded).employees;
        final updated =
            employees.where((employee) => employee.id != id).toList();

        if (context.mounted) {
          context.pop();
          context.pop();
          final t = AppLocalizations.of(context)!;
          showToast(
              text: t.employee_deleted_successfully,
              state: ToastStates.success);
        }

        emit(EmployeesLoaded(updated));
      },
    );
  }

  Future<void> addEmployeesSheet(
      {required BuildContext context, required String file}) async {
    if (state is! EmployeesLoaded) return;

    await _employeesService.addEmployeeFile(file: file);
  }

  Future<void> addEmployee({
    required String name,
    required String phone,
    required String email,
    required String idNumber,
    required double? limit,
    required BuildContext context,
    OnValidation? onValidation,
  }) async {
    if (state is! EmployeesLoaded) return;

    await runFetch(
      context: context,
      fetch: () async {
        final user = await _employeesService.addSingleEmployee(
          name: name,
          phone: phone,
          email: email,
          idNumber: idNumber,
          limit: limit,
        );

        final employees = (state as EmployeesLoaded).employees;
        final added = [...employees, user];

        if (context.mounted) {
          context.pop();
        }

        emit(EmployeesLoaded(added));
      },
      onValidation: onValidation,
    );
  }

  Future<void> updateEmployee({
    required String name,
    required int id,
    required String email,
    required String phone,
    required String nationalId,
    required String limit,
    required BuildContext context,
  }) async {
    if (state is! EmployeesLoaded) return;

    await runFetch(
      context: context,
      fetch: () async {
        await _employeesService.updateEmployee(
            name: name,
            phone: phone,
            email: email,
            nationalId: nationalId,
            id: id,
            limit: limit);

        final employees = (state as EmployeesLoaded).employees;
        final updated = employees
            .map(
              (employee) => employee.id == id.toString()
                  ? employee.copyWith(
                      name: name,
                      phone: phone,
                      email: email,
                      nationalId: nationalId,
                      limit: double.parse(limit),
                    )
                  : employee,
            )
            .toList();

        emit(EmployeesLoaded(updated));
        if (context.mounted) {
          final t = AppLocalizations.of(context)!;
          showToast(
              text: t.employee_updated_successfully,
              state: ToastStates.success);
        }
      },
    );
  }

  Future<void> addBalanceToEmployee({
    required int id,
    required double amount,
    required EnumPaymentMethod paymentMethod,
    required BuildContext context,
  }) async {
    if (state is! EmployeesLoaded) return;
    await runFetch(
      context: context,
      fetch: () async {
        await _employeesService.addBalanceToEmployee(
            amount: amount, id: id, paymentMethod: paymentMethod);

        final employees = (state as EmployeesLoaded).employees;
        final updated = employees
            .map(
              (employee) => employee.id == id.toString()
                  ? employee.copyWith(limit: employee.limit + amount)
                  : employee,
            )
            .toList();
        emit(EmployeesLoaded(updated));
        if (context.mounted) {
          final t = AppLocalizations.of(context)!;
          showToast(
              text: t.amount_added_successfully, state: ToastStates.success);
        }
      },
    );
  }
}
