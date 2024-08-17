import 'dart:async';
import 'dart:ui';

import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/infinite_list_view.dart';
import 'package:future_hub/employee/orders/cubit/employee_punchers_cubit.dart';
import 'package:future_hub/employee/orders/cubit/employee_punchers_state.dart';
import 'package:future_hub/employee/orders/widgets/puncher_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/shared/widgets/loading_indicator.dart';
import '../../../common/shared/widgets/map_widget.dart';

class EmployeeNewOrderScreen extends StatefulWidget {
  const EmployeeNewOrderScreen({super.key});

  @override
  State<EmployeeNewOrderScreen> createState() => _EmployeeNewOrderScreenState();
}

class _EmployeeNewOrderScreenState extends State<EmployeeNewOrderScreen> {
  Future<void> _onLoadMore() async {
    return BlocProvider.of<EmployeePunchersCubit>(context).loadPunchers();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return BlocConsumer<EmployeePunchersCubit, EmployeePunchersState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = EmployeePunchersCubit.get(context);
        if (state is PunchersLoadingState && state.isFirstFetch) {
          return const PaginatorLoadingIndicator();
        }
        bool canLoadMore = true;
        if (state is PunchersLoadingState) {
          // cubit.changeCubitPunchers(state.oldPunchers);
        } else if (state is PunchersLoadedState) {
          // cubit.changeCubitPunchers(state.punchers);
          canLoadMore = state.canLoadMore;
        }
        return Scaffold(
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24.0),
                  const Column(
                    children: [
                      // SizedBox(
                      //   height: size.height * 0.11,
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: ChevronButton(
                      //           onPressed: () {
                      //             cubit.changeScreenIndex(
                      //                 0, cubit.cubitPunchers);
                      //           },
                      //           style: ChevronButtonStyle.dashed(
                      //             filled: cubit.screenIndex == 0,
                      //           ),
                      //           child: Column(
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.stretch,
                      //             children: [
                      //               SvgPicture.asset(
                      //                 "assets/icons/menu.svg",
                      //                 colorFilter: ColorFilter.mode(
                      //                     cubit.screenIndex == 0
                      //                         ? Colors.white
                      //                         : Palette.primaryColor,
                      //                     BlendMode.srcATop),
                      //               ),
                      //               const SizedBox(height: 8.0),
                      //               Text(t.choose_by_name),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(width: 8.0),
                      //       Expanded(
                      //         child: ChevronButton(
                      //           onPressed: () {
                      //             cubit.changeScreenIndex(
                      //                 1, cubit.cubitPunchers);
                      //           },
                      //           style: ChevronButtonStyle.dashed(
                      //             filled: cubit.screenIndex == 1,
                      //           ),
                      //           child: Column(
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.stretch,
                      //             children: [
                      //               SvgPicture.asset(
                      //                 "assets/icons/satellite.svg",
                      //                 colorFilter: ColorFilter.mode(
                      //                     cubit.screenIndex == 1
                      //                         ? Colors.white
                      //                         : Palette.primaryColor,
                      //                     BlendMode.srcATop),
                      //               ),
                      //               const SizedBox(height: 8.0),
                      //               Text(t.choose_from_map),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  //   child: Text(
                  //     cubit.screenIndex == 0
                  //         ? t.choose_by_name
                  //         : t.choose_from_map,
                  //     style: theme.textTheme.titleLarge,
                  //   ),
                  // ),
                  if (cubit.screenIndex == 0) ...[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        t.all_stores2,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Palette.blackColor),
                      ),
                    ),
                  ],
                  Expanded(
                    child: cubit.screenIndex == 0
                        ? InfiniteListView(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => context.push(
                                    '/employee/puncher-screen/${cubit.cubitPunchers[index].id}',
                                    extra: cubit
                                        .cubitPunchers[index].puncher.name),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: PuncherCard(
                                    location: cubit
                                        .cubitPunchers[index].city!.title
                                        .toString(),
                                    distance: cubit
                                        .cubitPunchers[index].distance
                                        .toString(),
                                    title:
                                        "${cubit.cubitPunchers[index].puncher.name}  (${cubit.cubitPunchers[index].title})",
                                    imageUrl: cubit
                                        .cubitPunchers[index].puncher.imageUrl,
                                  ),
                                ),
                              );
                            },
                            itemCount: cubit.cubitPunchers.length,
                            canLoadMore: canLoadMore,
                            onLoadMore: _onLoadMore,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: MapWidget(
                              cubit: cubit,
                            ),
                          ),
                  )
                ],
              ),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Container(
                    color: Palette.whiteColor.withOpacity(0.6),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.05,
                        bottom: size.height * 0.04,
                        left: size.width * 0.02,
                        right: size.width * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cubit.screenIndex == 0
                              ? GestureDetector(
                                  onTap: () {
                                    cubit.changeScreenIndex(
                                        1, cubit.cubitPunchers);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/icons/pin.svg'),
                                      Text(
                                        t.map,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Palette.blackColor,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    cubit.changeScreenIndex(
                                        0, cubit.cubitPunchers);
                                  },
                                  child: SvgPicture.asset(
                                      'assets/icons/stores.svg')),
                          Padding(
                            padding: EdgeInsets.only(
                              left: Directionality.of(context) ==
                                      TextDirection.rtl
                                  ? MediaQuery.of(context).size.width * 0.1
                                  : 0.0,
                              right: Directionality.of(context) ==
                                      TextDirection.ltr
                                  ? MediaQuery.of(context).size.width * 0.1
                                  : 0.0,
                            ),
                            child: Text(
                              cubit.screenIndex == 0
                                  ? t.all_stores
                                  : t.near_stores,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Palette.blackColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                              color: Palette.blackColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
