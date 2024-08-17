import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/chevron_card.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<String> radioValues = [];

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final List<PaymentMethod> paymentCards = [
      // PaymentMethod(
      //     title: t.credit_card,
      //     icon: 'assets/icons/master_card.svg',
      //     route: '/bank-transfer-screen?isBank=false'),
      // PaymentMethod(
      //     title: t.mada,
      //     icon: 'assets/images/mada.png',
      //     route: '/bank-transfer-screen?isBank=false'),
      // PaymentMethod(
      //     title: t.apple_pay,
      //     icon: 'assets/icons/apple_pay.svg',
      //     route: '/bank-transfer-screen?isBank=false'),
      PaymentMethod(
          title: t.bank_transfer,
          icon: 'assets/icons/bank.svg',
          route: '/bank-transfer-screen?isBank=true'),
    ];
    final theme = Theme.of(context);
    return Scaffold(
      appBar: FutureHubAppBar(
        title: Text(t.deposit_method),
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: paymentCards.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ChevronCard(
                    onPressed: () => setState(() {
                      activeIndex = index;
                    }),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: index,
                              groupValue: activeIndex,
                              onChanged: (value) {
                                setState(() {
                                  activeIndex = value!;
                                });
                              },
                              activeColor: Palette.primaryColor,
                            ),
                            Text(
                              paymentCards[index].title,
                              style: theme.textTheme.headlineSmall!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        index == 1
                            ? Image.asset(
                                paymentCards[1].icon,
                                height: 20,
                              )
                            : SvgPicture.asset(
                                paymentCards[index].icon,
                                height: 25,
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 40.0,
            ),
            ChevronButton(
              onPressed: () {
                context.push(
                  paymentCards[activeIndex].route,
                  extra: paymentCards[activeIndex].title,
                );
              },
              child: Text(t.proceed_to_payment),
            )
          ],
        ),
      ),
    );
  }
}

class PaymentMethod {
  String title;
  String icon;
  String route;

  PaymentMethod({required this.title, required this.icon, required this.route});
}
