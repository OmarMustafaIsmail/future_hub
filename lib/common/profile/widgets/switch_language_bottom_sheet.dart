import 'package:future_hub/common/info/cubit/info_cubit.dart';
import 'package:future_hub/common/shared/cubits/locale_cubit.dart';
import 'package:future_hub/common/shared/cubits/orders_cubit/orders_cubit.dart';
import 'package:future_hub/common/shared/cubits/wallet_cubit/wallet_cubit.dart';
import 'package:future_hub/common/shared/widgets/chevron_bottom_sheet.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../employee/orders/cubit/employee_punchers_cubit.dart';

class SwitchLanguageBottomSheet extends StatelessWidget {
  const SwitchLanguageBottomSheet({super.key});

  static switchLanguage(BuildContext context, {String language = 'en'}) async {
    // final t = AppLocalizations.of(context)!;
    // final langCode = t.localeName == 'ar' ? 'en' : 'ar';
    final locale = Locale(language);

    context.read<LocaleCubit>().changeLocale(locale);

    // if (context.mounted) {
    //   await context.read<ProductsCubit>().loadProducts(context,);
    // }
    if (context.mounted) {
      await context.read<InfoCubit>().init();
    }
    if (context.mounted) {
      await context.read<EmployeePunchersCubit>().loadPunchers(refresh: true);
    }
    if (context.mounted) {
      await context.read<OrdersCubit>().loadOrders(refresh: true);
    }

    if (context.mounted) {
      context.read<WalletCubit>().loadTransactions(context, refresh: true);
    }
    // if (context.mounted) {
    //   context.pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final language = t.localeName == 'ar' ? 'English' : 'العربية';

    return ChevronBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.switch_the_apps_language,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          ChevronButton(
            onPressed: () => switchLanguage(context),
            child: Text(language),
          ),
          const SizedBox(height: 16.0),
          ChevronButton(
            onPressed: context.pop,
            style: ChevronButtonStyle.text(),
            child: Text(t.back),
          ),
        ],
      ),
    );
  }
}
