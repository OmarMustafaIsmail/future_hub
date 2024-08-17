import 'package:future_hub/common/auth/models/user.dart';
import 'package:future_hub/common/auth/screens/choose_language_screen.dart';
import 'package:future_hub/common/auth/screens/login_screen.dart';
import 'package:future_hub/common/auth/screens/otp_screen.dart';
import 'package:future_hub/common/auth/screens/password_recovery_otp_screen.dart';
import 'package:future_hub/common/auth/screens/password_recovery_phone_screen.dart';
import 'package:future_hub/common/auth/screens/password_recovery_screen.dart';
import 'package:future_hub/common/auth/screens/password_screen.dart';
import 'package:future_hub/common/auth/screens/sign_up_screen.dart';
import 'package:future_hub/common/info/screens/about_screen.dart';
import 'package:future_hub/common/info/screens/faq_screen.dart';
import 'package:future_hub/common/info/screens/privacy_policy_screen.dart';
import 'package:future_hub/common/info/screens/terms_conditions_screen.dart';
import 'package:future_hub/common/onBoarding/on_boarding_screen.dart';
import 'package:future_hub/common/points/models/user_gift.dart';
import 'package:future_hub/common/points/screens/points_added_screen.dart';
import 'package:future_hub/common/points/screens/points_redeemed_screen.dart';
import 'package:future_hub/common/points/screens/scan_product_points_code_screen.dart';
import 'package:future_hub/common/profile/screens/account_data_screen.dart';
import 'package:future_hub/common/profile/screens/change_password_screen.dart';
import 'package:future_hub/common/profile/screens/profile_screen.dart';
import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/models/products.dart';
import 'package:future_hub/common/shared/settings/screens/language_screen.dart';
import 'package:future_hub/common/shared/settings/screens/setting_screen.dart';
import 'package:future_hub/common/shared/settings/screens/support_screen.dart';
import 'package:future_hub/common/splash/splash_screen.dart';
import 'package:future_hub/common/wallet/models/transaction_model.dart';
import 'package:future_hub/common/wallet/screens/payment_methods_screen.dart';
import 'package:future_hub/common/wallet/screens/transaction_screen.dart';
import 'package:future_hub/company/coupons/coupons_screen.dart';
import 'package:future_hub/company/employees/screens/add_group_employees_screen.dart';
import 'package:future_hub/company/employees/screens/add_single_employee_screen.dart';
import 'package:future_hub/company/employees/screens/edit_employee_screen.dart';
import 'package:future_hub/company/employees/screens/employee_details_screen.dart';
import 'package:future_hub/company/employees/screens/employee_wallet_screen.dart';
import 'package:future_hub/company/layout/screens/company_layout_screen.dart';
import 'package:future_hub/company/products/screens/product_details_screen.dart';
import 'package:future_hub/employee/home/screens/employee_home_screen.dart';
import 'package:future_hub/employee/oil/screens/oil_search_result_screen.dart';
import 'package:future_hub/employee/oil/screens/oil_search_screen.dart';
import 'package:future_hub/employee/orders/screens/employee_new_order_screen.dart';
import 'package:future_hub/employee/orders/screens/employee_order_details_screen.dart';
import 'package:future_hub/employee/orders/screens/employee_puncher_screen.dart';
import 'package:future_hub/puncher/home/screens/puncher_home_screen.dart';
import 'package:future_hub/puncher/orders/screens/puncher_order_details_screen.dart';
import 'package:future_hub/puncher/orders/screens/puncher_orders_screen.dart';
import 'package:future_hub/puncher/orders/screens/recieve_order_screen.dart';
import 'package:go_router/go_router.dart';

import '../points/screens/points_partners_screen.dart';
import '../points/screens/points_screen.dart';
import '../wallet/screens/bank_transfer_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/support_screen',
      builder: (context, state) => const SupportScreen(),
    ),
    GoRoute(
      path: '/choose_language_screen',
      builder: (context, state) => const ChooseLanguageScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/onBoarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/password/:phone',
      builder: (context, state) => PasswordScreen(
        phoneNumber: state.pathParameters['phone']!,
      ),
    ),
    GoRoute(
      path: '/otp/:phone',
      builder: (context, state) => OTPScreen(
        phoneNumber: state.pathParameters['phone']!,
      ),
    ),
    GoRoute(
      path: '/password-recovery/phone',
      builder: (context, state) => const PasswordRecoveryPhoneScreen(),
    ),
    GoRoute(
      path: '/puncher-orders-screen',
      builder: (context, state) => const PuncherOrdersScreen(),
    ),
    GoRoute(
      path: '/password-recovery/otp/:phone',
      builder: (context, state) => PasswordRecoveryOTPScreen(
        phoneNumber: state.pathParameters['phone']!,
      ),
    ),
    GoRoute(
      path: '/password-recovery/change',
      builder: (context, state) => const PasswordRecoveryScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/puncher',
      builder: (context, state) => const PuncherHomeScreen(),
    ),
    GoRoute(
      path: '/puncher/recieve-order',
      builder: (context, state) => const RecieveOrderScreen(),
    ),
    GoRoute(
      path: '/puncher/order-details',
      builder: (context, state) => PuncherOrderDetailsScreen(
        order: state.extra as Order,
      ),
    ),
    GoRoute(
      path: '/company',
      builder: (context, state) => const CompanyLayoutScreen(),
    ),
    GoRoute(
      path: '/company/product/:id',
      builder: (context, state) => ProductDetailsScreen(
        state.pathParameters['id']!,
        product: state.extra as CompanyProduct,
        company: state.queryParameters['company'] == 'true',
      ),
    ),
    GoRoute(
      path: '/company/employee/:id',
      builder: (context, state) =>
          EmployeeDetailsScreen(state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/company/employees/add-single',
      builder: (context, state) => const AddSingleEmployee(),
    ),
    GoRoute(
      path: '/company/employees/add-group',
      builder: (context, state) => const AddGroupEmployees(),
    ),
    GoRoute(
      path: '/employee',
      builder: (context, state) => EmployeeHomeScreen(
        onTapBalance: () {},
      ),
    ),
    GoRoute(
      path: '/account-data',
      builder: (context, state) => const AccountDataScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/wallet/transaction',
      builder: (context, state) => TransactionScreen(
        transaction: state.extra as Transaction,
      ),
    ),
    GoRoute(
      path: '/coupons',
      builder: (context, state) => const CouponsScreen(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => const TermsConditionsScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/points',
      builder: (context, state) => const PointsScreen(),
    ),
    GoRoute(
      path: '/points/points_partners',
      builder: (context, state) => const PointPartnersScreen(),
    ),
    GoRoute(
      path: '/points/scan-product',
      builder: (context, state) => const ScanProductPointsCodeScreen(),
    ),
    GoRoute(
      path: '/points/added',
      builder: (context, state) => PointsAddedScreen(
        points: int.parse(state.queryParameters['points']!),
      ),
    ),
    GoRoute(
      path: '/points/redeemed',
      builder: (context, state) => PointsRedeemedScreen(
        userGift: state.extra as UserGift,
        old: state.queryParameters.containsKey('old'),
      ),
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/faq',
      builder: (context, state) => const FAQScreen(),
    ),
    GoRoute(
      path: '/employee/new-order',
      builder: (context, state) => const EmployeeNewOrderScreen(),
    ),
    GoRoute(
      path: '/employee/puncher-screen/:id',
      builder: (context, state) => EmployeePuncherScreen(
        int.parse(state.pathParameters['id']!),
        name: state.extra as String,
      ),
    ),
    GoRoute(
      path: '/employee/oil/search',
      builder: (context, state) => const OilSearchScreen(),
    ),
    GoRoute(
      path: '/employee/oil/result',
      builder: (context, state) => const OilSearchResultScreen(),
    ),
    GoRoute(
      path: '/employee/order-details',
      builder: (context, state) => EmployeeOrderDetailsScreen(
        order: state.extra as Order,
        showActivate: state.queryParameters['showButton'] == "true",
      ),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/edit-employee',
      builder: (context, state) =>
          EditEmployeeScreen(employee: state.extra as User),
    ),
    GoRoute(
      path: '/company/employee/:id/employee-wallet',
      builder: (context, state) => EmployeeWalletScreen(
        id: int.parse(state.pathParameters['id']!),
        balance: double.parse(state.queryParameters['balance']!),
      ),
    ),
    GoRoute(
      path: '/payment-methods-screen',
      builder: (context, state) => const PaymentMethodsScreen(),
    ),
    GoRoute(
      path: '/bank-transfer-screen',
      builder: (context, state) => PaymentScreen(
        isBank: state.queryParameters['isBank'] == "true",
        title: state.extra.toString(),
      ),
    ),
    GoRoute(
      path: '/settings_screen',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/language_screen',
      builder: (context, state) => const LanguageScreen(),
    ),
  ],
);
