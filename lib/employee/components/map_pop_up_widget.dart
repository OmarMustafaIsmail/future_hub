import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MapPopUpWidget extends StatelessWidget {
  const MapPopUpWidget(
      {super.key,
      required this.title,
      this.imageUrl,
      this.showDirection = false,
      required this.location,
      this.phoneNumber,
      required this.id});

  final String title;
  final String? imageUrl;
  final bool showDirection;
  final String location;
  final String? phoneNumber;
  final int id;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Palette.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Center(
                      child: Container(
                        height: 207,
                        width: 253,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Palette.dangerColor,
                        ),
                        child: Image.network(
                          imageUrl ?? 'https://unsplash.it/100/100',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Palette.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/location-d.svg'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(102, 102, 102, 1),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (phoneNumber != null) ...[
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/mobile.svg'),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          phoneNumber!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                        )
                      ],
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ChevronButton(
                      onPressed: () => context
                          .push('/employee/puncher-screen/$id', extra: title),
                      child: Text(
                        t.products,
                        style: const TextStyle(
                          color: Palette.whiteColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Image.network(
              //       imageUrl ?? 'https://unsplash.it/100/100',
              //       width: 75,
              //       height: 75,
              //       fit: BoxFit.contain,
              //     ),
              //     const SizedBox(width: 12.0),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             title,
              //             style: theme.textTheme.bodyLarge!
              //                 .copyWith(fontSize: 17, fontWeight: FontWeight.w700),
              //           ),
              //           if (showDirection)
              //             Padding(
              //               padding: const EdgeInsets.only(top: 16.0),
              //               child: Row(
              //                 children: [
              //                   SvgPicture.asset("assets/icons/location.svg"),
              //                   const SizedBox(
              //                     width: 5,
              //                   ),
              //                   Text(
              //                     'على بعد 100م',
              //                     style: theme.textTheme.bodyMedium!
              //                         .copyWith(fontSize: 15),
              //                   )
              //                 ],
              //               ),
              //             )
              //         ],
              //       ),
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
