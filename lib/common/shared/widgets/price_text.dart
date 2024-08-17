import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PriceText extends StatelessWidget {
  final double price;

  const PriceText({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$price ',
            style: theme.textTheme.bodyLarge,
          ),
          TextSpan(
            text: t.sar,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
