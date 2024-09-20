import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:future_hub/common/auth/cubit/auth_state.dart';
import 'package:future_hub/common/auth/models/user.dart';
import 'package:future_hub/common/auth/services/auth_service.dart';
import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/points/services/points_service.dart';
import 'package:future_hub/common/shared/router.dart';
import 'package:future_hub/common/shared/utils/cache_manager.dart';
import 'package:future_hub/common/shared/utils/run_fetch.dart';
import 'package:future_hub/common/shared/widgets/flutter_toast.dart';

class AuthCubit extends Cubit<AuthState> {
  final _authService = AuthService();
  final _pointsService = PointsService();

  AuthCubit() : super(AuthLoading());

  Future<void> init() async {
    try {
      final onBoarding = await CacheManager.getData('onBoarding');
      final languageScreen = await CacheManager.getData('languageScreen');
      final token = await CacheManager.getToken();
      debugPrint("hehehe1234${token.toString()}");
      debugPrint("language screen from cubit is $languageScreen");
      if (languageScreen == null) {
        Future.delayed(const Duration(seconds: 2), () {
          router.go('/choose_language_screen');
        });
        return;
      }
      if (onBoarding == null) {
        Future.delayed(const Duration(seconds: 2), () {
          router.go('/onBoarding');
          Client.authenticate(null);
          CacheManager.deleteToken();
        });
        return;
      }

      if (token == null) {
        Future.delayed(const Duration(seconds: 2), () {
          router.go('/login');
        });
        return emit(AuthSignedOut());
      }
      Client.authenticate(token);

      final user = await _authService.me();

      await login(user, token);
    } catch (error) {
      debugPrint("Error is ${error.toString()}");
      Client.authenticate(null);
      CacheManager.deleteToken();
      return emit(AuthSignedOut());
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // FlutterNativeSplash.remove();
      });
    }
  }

  void setOTP(String otp) {
    final current = state;

    if (current is AuthSignedOut) {
      return emit(
        AuthSignedOut(
          otp: otp,
          phone: current.phone,
        ),
      );
    }

    throw Exception("Can't change OTP when AuthState isn't AuthSignedOut");
  }

  void setPhone(String phone) async {
    final token = await CacheManager.getToken();
    if (token == null) {
      emit(AuthSignedOut());
    }
    final current = state;
    debugPrint("the auth state is $state");
    if (current is AuthSignedOut) {
      return emit(
        AuthSignedOut(
          phone: phone,
          otp: current.otp,
        ),
      );
    }

    throw Exception("Can't change phone when AuthState isn't AuthSignedOut");
  }

  void signingEmployee(String name, String company) {
    debugPrint("token is ${CacheManager.getToken()}");
    final current = state;
    if (current is AuthSignedOut) {
      return emit(
        AuthEmployeeSigningIn(
          name: name,
          company: company,
          phone: current.phone,
          otp: current.otp,
        ),
      );
    }
    throw Exception("Can't sign in an employee when AuthState isn't AuthSignedOut");
  }

  // 0560498238
  Future<void> login(User user, String token) async {
    await CacheManager.setToken(token);
    Client.authenticate(token);

    emit(
      AuthSignedIn(
        token: token,
        user: user,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      switch (user.type) {
        case 'company':
          return router.go('/company');
        case 'customer':
          return router.go('/employee');
        default:
          return router.go('/puncher');
      }
    });
  }

  void signOut() async {
    router.go('/login');
    await _authService.logOut();
    Client.authenticate(null);
    CacheManager.deleteToken();
    FirebaseMessaging.instance.deleteToken();
    emit(AuthSignedOut());
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String email,
    required BuildContext context,
  }) async {
    await runFetch(
      context: context,
      fetch: () async {
        await _authService.updateProfile(
          name: name,
          phone: phone,
          email: email,
        );

        final current = state as AuthSignedIn;

        emit(
          AuthSignedIn(
            user: current.user.copyWith(
              name: name,
              phone: phone,
              email: email,
            ),
            token: current.token,
          ),
        );

        if (context.mounted) {
          final t = AppLocalizations.of(context)!;
          showToast(
            text: t.profile_updated_successfully,
            state: ToastStates.success,
          );
        }
      },
    );
  }

  Future<void> updateProfilePhoto({
    required String image,
    required BuildContext context,
  }) async {
    await _authService.updateProfilePhoto(image);

    final current = state as AuthSignedIn;

    emit(
      AuthSignedIn(
        user: current.user.copyWith(imageURL: image),
        token: current.token,
      ),
    );

    if (context.mounted) {
      final t = AppLocalizations.of(context)!;
      showToast(
        text: t.profile_photo_updated_successfully,
        state: ToastStates.success,
      );
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    await runFetch(
      context: context,
      fetch: () async {
        await _authService.deleteAccount();
        signOut();
      },
    );
  }

  Future<int?> gainPoints(BuildContext context, {required String code}) async {
    return runFetch<int>(
      context: context,
      fetch: () async {
        final points = await _pointsService.scanProductCode(code);

        final current = state as AuthSignedIn;

        emit(
          AuthSignedIn(
            user: current.user.copyWith(
              points: current.user.points + points,
            ),
            token: current.token,
          ),
        );

        return points;
      },
    );
  }
}
