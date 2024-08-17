import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/common/shared/widgets/chevron_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnterUserCodeView extends StatelessWidget {
  const EnterUserCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.08),
            Text(
              t.enter_user_code,
              style: theme.textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              t.enter_user_code_hint,
              style: theme.textTheme.bodySmall!
                  .copyWith(fontSize: 20, color: Palette.textGreyColor),
            ),
            SizedBox(
              height: height * 0.07,
            ),
            CustomTextField(
              haveBorderSide: true,
              radius: 15,
              label: t.user_code,
              hintText: '',
              validateFunc: (String? s) {
                return null;
              },
            ),
            SizedBox(
              height: height * 0.04,
            ),
            SizedBox(
              width: width * 0.4,
              child: ChevronButton(
                onPressed: () {},
                child: Text(
                  t.next,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
