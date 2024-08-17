import 'package:future_hub/common/auth/cubit/auth_cubit.dart';
import 'package:future_hub/common/auth/cubit/auth_state.dart';
import 'package:future_hub/common/shared/cubits/locale_cubit.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployeeHomeWalletCard extends StatefulWidget {
  const EmployeeHomeWalletCard({super.key});

  @override
  State<EmployeeHomeWalletCard> createState() => _EmployeeHomeWalletCardState();
}

class _EmployeeHomeWalletCardState extends State<EmployeeHomeWalletCard> {
  bool showBalance = false;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final size = MediaQuery.of(context).size;
    final t = AppLocalizations.of(context)!;

    double containerHeight =
        showBalance ? size.height * 0.15 : size.height * 0.15;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          AnimatedContainer(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: containerHeight,
            width: size.width,
            child: Image.asset(
              'assets/images/home-wallet-card.png',
              fit: BoxFit.contain,
            ),
          ),
          BlocBuilder<LocaleCubit, Locale?>(builder: (context, locale) {
            return Positioned.directional(
              top: showBalance ? 25 : 20,
              textDirection: direction,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        showBalance = !showBalance;
                      }),
                      child: SvgPicture.asset(
                        showBalance
                            ? 'assets/icons/eye.svg'
                            : 'assets/icons/employee-eye-view.svg',
                        height: showBalance
                            ? size.height * 0.015
                            : size.height * 0.03,
                        colorFilter: const ColorFilter.mode(
                            Palette.whiteColor, BlendMode.srcATop),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: showBalance ? size.height * 0.008 : 0),
                      child: Text(
                        showBalance ? t.hide : t.show,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Palette.whiteColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
          BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            final balance = (state is AuthSignedIn)
                ? state.user.wallet.toString()
                : t.your_balance;

            return Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: containerHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/employee-avatar.png',
                      height: size.height * 0.05,
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        text: showBalance ? balance : t.your_balance,
                        style: TextStyle(
                          fontSize: showBalance ? 20 : 15,
                          fontWeight: FontWeight.bold,
                          color: Palette.whiteColor,
                        ),
                        children: [
                          if (showBalance)
                            TextSpan(
                              text: ' ${t.sar}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
