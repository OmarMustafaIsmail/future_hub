import 'package:future_hub/common/info/cubit/info_cubit.dart';
import 'package:future_hub/common/info/cubit/info_state.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: FutureHubAppBar(
        context: context,
        title: Text(
          t.support,
          style: const TextStyle(
            fontSize: 22,
            color: Palette.blackColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: height * 0.04,
            ),
            Text(
              t.you_can_no_contact,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Text(
              t.email,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Stack(
              children: [
                Center(
                  child: Image.asset(
                      Directionality.of(context) == TextDirection.rtl
                          ? "assets/images/arabic_email.png"
                          : "assets/images/english_email.png"),
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: BlocBuilder<InfoCubit, InfoState>(
                          builder: (context, state) {
                        state as InfoLoaded;
                        return Text(
                          state.info.email,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        );
                      }),
                    ))
              ],
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Text(
              t.social_media,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Image.asset('assets/images/social_media.png'),
            SizedBox(
              height: height * 0.04,
            ),
            Center(
              child: Text(
                softWrap: true,
                textAlign: TextAlign.center,
                t.we_are_happy_to_contact_you,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'v1.0',
                    style: TextStyle(
                      fontSize: 22,
                      color: Palette.blackColor,
                    ),
                  ),
                  Text(
                    t.caltex,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Palette.blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
