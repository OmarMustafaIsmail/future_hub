
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:future_hub/common/auth/graphql/auth.gql.dart';
import 'package:future_hub/common/auth/models/company.dart';
import 'package:future_hub/common/auth/models/user.dart';
import 'package:future_hub/common/graphql/graphql_client.dart';

import '../../graphql/schema.gql.dart';
import '../../notifications/services/notifications_service.dart';
import '../../shared/utils/fetch_exception.dart';

class AuthService {
  Future<bool> validateMobile(String phone) async {
    final result = await Client.current.mutateValidateMobile(
      OptionsMutationValidateMobile(
        variables: VariablesMutationValidateMobile(
          phone: phone,
        ),
      ),
    );

    final data = result.parsedData?.validateMobile;
    final exists = data?.first_login;
    final status = data?.status;
    final message = data?.message;
    debugPrint("validate phone error $result");

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }
    debugPrint("validate phone error $result");
    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    return exists!;
  }

  Future<void> sendOTP(String phone, EnumVerifyEnum type) async {
    final result = await Client.current.mutateSendOTP(
      OptionsMutationSendOTP(
        variables: VariablesMutationSendOTP(
          phone: phone,
          type: type,
        ),
      ),
    );

    final data = result.parsedData?.sendMobileCode;
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

  Future<MutationConfirmOTPconfirmMobileCodeuser?> confirmOTP(
    String phone,
    String otp,
    EnumVerifyEnum type,
  ) async {
    final result = await Client.current.mutateConfirmOTP(
      OptionsMutationConfirmOTP(
        variables: VariablesMutationConfirmOTP(
          phone: phone,
          otp: otp,
          type: type,
        ),
      ),
    );

    final data = result.parsedData?.confirmMobileCode;
    final status = data?.status;
    final message = data?.message;
    final user = data?.user;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);

    return user;
  }

  Future<LoginResult> login(String phone, String password) async {
    final result = await Client.current.mutateLogina(
      OptionsMutationLogina(
        variables: VariablesMutationLogina(
          phone: phone,
          password: password,
        ),
      ),
    );
    debugPrint(result.data.toString());

    final data = result.parsedData?.login;
    final status = data?.status;
    final message = data?.message;
    final user = data?.user;
    final token = data?.token;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }
    NotificationsService().updateFCMToken(
        token: await FirebaseMessaging.instance.getToken(),
        userType: data!.user!.type!);

    debugPrint(message);

    return LoginResult(
      token: token!,
      user: User(
        id: user!.id,
        name: user.name,
        phone: user.mobile,
        gender: user.gender,
        nationalId: user.national_id,
        type: user.type,
        imageURL: user.image_path,
        active: user.active,
        username: user.username,
        birthDate: user.birth_date,
        email: user.email,
        limit: user.wallet_limit,
        spentAmount: user.withdrawal,
        wallet: user.wallet,
        points: user.points,
        company: Company(
          id: user.user_company?.id,
          name: user.user_company?.name,
          canUpdatePrice: user.user_company?.can_update_price,
          customerPointsBenefit: user.user_company?.customer_points_benefit,
          pointsBenefit: user.user_company?.points_benefit,
          imageURL: user.user_company?.image_path,
        ),
      ),
    );
  }

  Future<String> logOut() async {
    final result = await Client.current.mutateLogout();
    final data = result.parsedData?.logout;
    final status = data?.status;
    final message = data?.message;
    debugPrint(message);
    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }
    return message!;
  }

  Future<LoginResult> resetPassword({
    required String phone,
    required String otp,
    required String password,
    required String confirmPassword,
    required EnumVerifyEnum type,
  }) async {
    final result = await Client.current.mutateResetPasswordByCode(
      OptionsMutationResetPasswordByCode(
        variables: VariablesMutationResetPasswordByCode(
          phone: phone,
          otp: otp,
          password: password,
          confirmPassword: confirmPassword,
          type: type,
        ),
      ),
    );

    final data = result.parsedData?.resetPasswordByCode;
    final status = data?.status;
    final message = data?.message;
    final user = data?.user;
    final token = data?.token;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);

    return LoginResult(
      token: token!,
      user: User(
        id: user!.id,
        name: user.name,
        phone: user.mobile,
        gender: user.gender,
        nationalId: user.national_id,
        type: user.type,
        imageURL: user.image_path,
        active: user.active,
        username: user.username,
        birthDate: user.birth_date,
        email: user.email,
        limit: user.wallet_limit,
        spentAmount: user.withdrawal,
        wallet: user.wallet,
        points: user.points,
        company: Company(
          id: user.user_company?.id,
          name: user.user_company?.name,
          canUpdatePrice: user.user_company?.can_update_price,
          customerPointsBenefit: user.user_company?.customer_points_benefit,
          pointsBenefit: user.user_company?.points_benefit,
          imageURL: user.user_company?.image_path,
        ),
      ),
    );
  }

  Future<User> me() async {
    final result = await Client.current.queryMe();

    final data = result.parsedData?.me;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    return User(
      id: data!.id,
      name: data.name,
      phone: data.mobile,
      gender: data.gender,
      nationalId: data.national_id,
      type: data.type,
      imageURL: data.image_path,
      active: data.active,
      username: data.username,
      birthDate: data.birth_date,
      email: data.email,
      limit: data.wallet_limit,
      spentAmount: data.withdrawal,
      wallet: data.wallet,
      points: data.points,
      company: Company(
        id: data.user_company?.id,
        name: data.user_company?.name,
        canUpdatePrice: data.user_company?.can_update_price,
        customerPointsBenefit: data.user_company?.customer_points_benefit,
        pointsBenefit: data.user_company?.points_benefit,
        imageURL: data.user_company?.image_path,
      ),
    );
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String email,
  }) async {
    final result = await Client.current.mutateUpdateProfile(
      OptionsMutationUpdateProfile(
        variables: VariablesMutationUpdateProfile(
          name: name,
          phone: phone,
          email: email,
        ),
      ),
    );

    final data = result.parsedData?.updateProfile;
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

  Future<void> updateProfilePhoto(String image) async {
    final result = await Client.current.mutateUpdateProfilePhoto(
      OptionsMutationUpdateProfilePhoto(
        variables: VariablesMutationUpdateProfilePhoto(image: image),
      ),
    );

    final data = result.parsedData?.updateProfilePhoto;
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

  Future<void> updatePassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    final result = await Client.current.mutateUpdatePassword(
      OptionsMutationUpdatePassword(
        variables: VariablesMutationUpdatePassword(
          oldPassword: oldPassword,
          password: password,
          confirmPassword: passwordConfirmation,
        ),
      ),
    );

    final data = result.parsedData?.updatePassword;
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

  Future<void> deleteAccount() async {
    final result = await Client.current.mutateDeleteAccount();

    final data = result.parsedData?.deleteAccount;
    final status = data?.status;
    final message = data?.message;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    FirebaseMessaging.instance.deleteToken();

    debugPrint(message);
  }
}

class LoginResult {
  final User user;
  final String token;

  const LoginResult({
    required this.user,
    required this.token,
  });
}
