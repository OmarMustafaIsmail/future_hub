import 'package:future_hub/common/auth/models/user.dart';
import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/graphql/schema.gql.dart';
import 'package:future_hub/common/shared/utils/fetch_exception.dart';
import 'package:future_hub/common/shared/utils/paginator_info.dart';
import 'package:future_hub/common/shared/widgets/flutter_toast.dart';
import 'package:future_hub/company/employees/graphql/employees.gql.dart';
import 'package:flutter/material.dart';

class EmployeesService {
  Future<PaginatorInfo<User>> getEmployees({int page = 1}) async {
    final result = await Client.current.queryEmployees(
      OptionsQueryEmployees(
        variables: VariablesQueryEmployees(
          page: page,
        ),
      ),
    );

    final data = result.parsedData?.employees;
    final employees = data!.data;
    final hasMorePages = data.paginatorInfo.hasMorePages;
    final total = data.paginatorInfo.total;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    return PaginatorInfo(
      data: employees
          .map(
            (user) => User(
              id: user.id,
              limit: user.wallet_limit,
              name: user.name,
              email: user.email,
              phone: user.mobile,
              imageURL: user.image_path,
              nationalId: user.national_id,
              type: user.type,
              wallet: user.wallet,
              spentAmount: user.withdrawal,
              active: user.active,
              createdAt: user.created_at != null
                  ? DateTime.parse(user.created_at!)
                  : null,
            ),
          )
          .toList(),
      hasMorePages: hasMorePages,
      total: total,
    );
  }

  Future<User> addSingleEmployee({
    required String name,
    required String phone,
    required String email,
    required String idNumber,
    required double? limit,
  }) async {
    final result = await Client.current.mutateAddSingleEmployee(
      OptionsMutationAddSingleEmployee(
        variables: VariablesMutationAddSingleEmployee(
          name: name,
          phone: phone,
          email: email,
          idNumber: idNumber,
          limit: limit,
        ),
      ),
    );

    final data = result.parsedData?.createEmployee;
    final user = data?.user;
    final status = data?.status;
    final message = data?.message;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);

    return User(
      id: user!.id,
      limit: user.wallet_limit,
      name: user.name,
      email: user.email,
      phone: user.mobile,
      imageURL: user.image_path,
      nationalId: user.national_id,
      type: user.type,
      wallet: user.wallet,
      spentAmount: user.withdrawal,
      active: user.active,
      createdAt: user.created_at != null
          ? DateTime.parse(user.created_at!)
          : DateTime.now(),
    );
  }

  Future<void> stopEmployee({required int id}) async {
    final result = await Client.current.mutateStopEmployee(
      OptionsMutationStopEmployee(
        variables: VariablesMutationStopEmployee(
          id: id,
        ),
      ),
    );

    final data = result.parsedData?.stopEmployee;
    final status = data?.status;
    final message = data?.message;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);
  }

  Future<void> activateEmployee({required int id}) async {
    final result = await Client.current.mutateActivateEmployee(
      OptionsMutationActivateEmployee(
        variables: VariablesMutationActivateEmployee(
          id: id,
        ),
      ),
    );

    final data = result.parsedData?.activeEmployee;
    final status = data?.status;
    final message = data?.message;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);
  }

  Future<void> updateEmployee({
    required String name,
    required String email,
    required String phone,
    required int id,
    required String nationalId,
    required String limit,
  }) async {
    final result = await Client.current.mutateEditEmployee(
      OptionsMutationEditEmployee(
        variables: VariablesMutationEditEmployee(
            name: name,
            phone: phone,
            email: email,
            idNumber: nationalId,
            id: id,
            limit: double.parse(limit)),
      ),
    );
    final data = result.parsedData?.updateEmployee;
    final status = data?.status;
    final message = data?.message;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);
  }

  Future<void> deleteEmployee({required int id}) async {
    final result = await Client.current.mutateDeleteEmployee(
      OptionsMutationDeleteEmployee(
        variables: VariablesMutationDeleteEmployee(
          id: id,
        ),
      ),
    );

    final data = result.parsedData?.deleteEmployee;
    final status = data?.status;
    final message = data?.message;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);
  }

  Future<void> addBalanceToEmployee(
      {required int id,
      required double amount,
      required EnumPaymentMethod paymentMethod}) async {
    final result = await Client.current.mutateAddToEmployeeWallet(
      OptionsMutationAddToEmployeeWallet(
        variables: VariablesMutationAddToEmployeeWallet(
            id: id.toString(), amount: amount, payment_method: paymentMethod),
      ),
    );

    final data = result.parsedData?.createWalletEmployee;
    final status = data?.status;
    final message = data?.message;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }
    debugPrint(message);
  }

  Future<void> addEmployeeFile({required String file}) async {
    final result = await Client.current.mutateAddEmployeeFile(
      OptionsMutationAddEmployeeFile(
        variables: VariablesMutationAddEmployeeFile(
          file: file,
        ),
      ),
    );

    final data = result.parsedData?.uploadEmployee;
    final status = data?.status;
    final message = data?.message;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      showToast(text: message!, state: ToastStates.error);
      throw FetchException(message);
    }
    debugPrint(message);
    showToast(text: message!, state: ToastStates.success);
  }
}
