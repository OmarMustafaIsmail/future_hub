import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/shared/palette.dart';

class PuncherCard extends StatelessWidget {
  const PuncherCard(
      {super.key,
      required this.title,
      this.imageUrl,
      this.showDirection = false,
      required this.location,
      required this.distance});

  final String title;
  final String? imageUrl;
  final bool showDirection;
  final String location;
  final String distance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height * 0.1,
                  width: width * 0.25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red),
                  child: Image.network(
                    imageUrl ?? 'https://unsplash.it/100/100',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                child: Text(
                                  title,
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Palette.primaryColor),
                                ),
                              ),
                            ),
                            if (distance != 'null') ...[
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/icons/location-d.svg"),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        distance,
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          location,
                          style: theme.textTheme.bodyMedium!.copyWith(
                              color: const Color.fromRGBO(160, 160, 160, 1),
                              fontSize: 20),
                        ),
                      )
                      // if (showDirection)
                      //   Padding(
                      //     padding: const EdgeInsets.only(top: 16.0),
                      //     child: Row(
                      //       children: [
                      //         SvgPicture.asset("assets/icons/location-d.svg"),
                      //         const SizedBox(
                      //           width: 5,
                      //         ),
                      //         Text(
                      //           distance,
                      //           style: theme.textTheme.bodyMedium!
                      //               .copyWith(fontSize: 15),
                      //         )
                      //       ],
                      //     ),
                      //   )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Divider(
            color: Colors.grey.withOpacity(0.25),
            thickness: 1,
            endIndent: 10,
            indent: 10,
          ),
        )
      ],
    );
  }
}
