// import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/cubits/drawer_cubit/cubit.dart';
import 'package:future_hub/common/shared/cubits/drawer_cubit/states.dart';
import 'package:future_hub/common/shared/utils/cache_manager.dart';
import 'package:future_hub/common/shared/widgets/drawer_screen.dart';
import 'package:future_hub/common/shared/widgets/home_app_bar.dart';
import 'package:future_hub/common/shared/widgets/home_hint.dart';
import 'package:future_hub/puncher/components/orders_listview.dart';
import 'package:future_hub/puncher/components/puncher_bottom_navbar.dart';
import 'package:future_hub/puncher/components/puncher_new_order_card.dart';
// import 'package:future_hub/puncher/orders/screens/puncher_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PuncherHomeScreen extends StatefulWidget {
  const PuncherHomeScreen({super.key});

  @override
  State<PuncherHomeScreen> createState() => _PuncherHomeScreenState();
}

class _PuncherHomeScreenState extends State<PuncherHomeScreen> {
  bool isDrawerOpen = false;
  bool showHint = false;

  showHintFunc() async {
    if (await CacheManager.getData('home-hint') == null) {
      setState(() {
        showHint = true;
      });
    } else {
      setState(() {
        showHint = false;
      });
    }
  }

  @override
  void initState() {
    showHintFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final t = AppLocalizations.of(context)!;
    // final theme = Theme.of(context);
    final bool arabic = Directionality.of(context) == TextDirection.rtl;
    final paddingTop = MediaQuery.of(context).padding.top;
    return BlocBuilder<DrawerCubit,DrawerStates>(
      builder: (context,state) {
        isDrawerOpen = (state as DrawerDataState).isDrawerOpen;
        return Scaffold(
          body: Stack(
            children: [
              const DrawerScreen(),
              AnimatedContainer(
                height: MediaQuery.of(context).size.height,
                transform: Matrix4.translationValues(
                    isDrawerOpen
                        ? arabic
                            ? -MediaQuery.of(context).size.width * 0.28
                            : MediaQuery.of(context).size.width * 0.37
                        : 0.0,
                    isDrawerOpen
                        ? arabic
                            ? 90
                            : 130
                        : 0.0,
                    0)
                  ..scale(isDrawerOpen ? 0.78 : 1.00)
                  ..rotateZ(isDrawerOpen
                      ? arabic
                          ? 0.1
                          : -0.1
                      : 0),
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: isDrawerOpen
                      ? BorderRadius.circular(40)
                      : BorderRadius.circular(0),
                ),
              ),
              AnimatedContainer(
                height: MediaQuery.of(context).size.height,
                transform: Matrix4.translationValues(
                    isDrawerOpen
                        ? arabic
                            ? -MediaQuery.of(context).size.width * 0.42
                            : MediaQuery.of(context).size.width * 0.45
                        : 0.0,
                    isDrawerOpen
                        ? arabic
                            ? 55
                            : 90
                        : 0.0,
                    0)
                  ..scale(isDrawerOpen ? 0.85 : 1.00)
                  ..rotateZ(isDrawerOpen
                      ? arabic
                          ? 0.1
                          : -0.1
                      : 0),
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: isDrawerOpen
                      ? BorderRadius.circular(40)
                      : BorderRadius.circular(0),
                ),
              ),
              AnimatedContainer(
                height: MediaQuery.of(context).size.height,
                transform: Matrix4.translationValues(
                    isDrawerOpen
                        ? arabic
                            ? -MediaQuery.of(context).size.width * 0.55
                            : MediaQuery.of(context).size.width * 0.55
                        : 0.0,
                    isDrawerOpen
                        ? arabic
                            ? 30
                            : 60
                        : 0.0,
                    0)
                  ..scale(isDrawerOpen ? 0.90 : 1.00)
                  ..rotateZ(isDrawerOpen
                      ? arabic
                          ? 0.1
                          : -0.1
                      : 0),
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: isDrawerOpen
                      ? BorderRadius.circular(40)
                      : BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: paddingTop),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeAppBar(
                        icon: GestureDetector(
                          onTap: () => setState(() {
                            context.read<DrawerCubit>().changeDrawerState();
                          }),
                          child: Transform.flip(
                            flipX: !arabic,
                            child: SvgPicture.asset(
                              isDrawerOpen
                                  ? 'assets/icons/close.svg'
                                  : 'assets/icons/drawer.svg',
                              height: isDrawerOpen ? 40 : 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          bottom: 18.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () => context.push('/puncher/recieve-order'),
                              child: const PuncherNewOrderCard(),
                            ),
                            // ListView.separated(
                            //   itemBuilder: (context, index) {
                            //     return Container();
                            //   },
                            //   separatorBuilder: (context, index) {
                            //     return const Divider();
                            //   },
                            //   itemCount: 1,
                            // )
                          ],
                        ),
                      ),
                      const Expanded(child: PuncherOrdersListView()),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: buildBottomNavBar(context, arabic),
                ),
              ),
              if (showHint)
                HomeHint(
                  onPressed: () {
                    CacheManager.saveData('home-hint', 'true');
                    setState(() {
                      showHint = false;
                    });
                  },
                ),
              Positioned(
                bottom: 30,
                right: 0,
                left: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: buildCenterLogo(context, arabic),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget buildBottomNavBar(BuildContext context, bool arabic) {
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      height: MediaQuery.of(context).size.height,
      transform: Matrix4.translationValues(
          isDrawerOpen
              ? size.width > 420
                  ? arabic
                      ? -size.width * 0.73
                      : size.width * 0.74
                  : arabic
                      ? -size.width * 0.71
                      : size.width * 0.71
              : 0.0,
          isDrawerOpen
              ? arabic
                  ? -size.height * 0.04
                  : size.height * 0.01
              : 0.0,
          0)
        ..scale(isDrawerOpen ? 0.90 : 1.00)
        ..rotateZ(isDrawerOpen
            ? arabic
                ? 0.1
                : -0.1
            : 0),
      duration: const Duration(milliseconds: 300),
      child: const PuncherBottomNavBar(),
    );
  }

  Widget buildCenterLogo(BuildContext context, bool arabic) {
    logoPressed() {
      if (showHint) {
        CacheManager.saveData('home-hint', 'true');
        setState(() {
          showHint = false;
        });
        context.push('/puncher/recieve-order');
        return;
      }
      context.push('/puncher/recieve-order');
    }

    return AnimatedContainer(
      height: MediaQuery.of(context).size.height,
      transform: Matrix4.translationValues(
          isDrawerOpen
              ? arabic
                  ? -MediaQuery.of(context).size.width * 0.55
                  : MediaQuery.of(context).size.width * 0.80
              : 0.0,
          isDrawerOpen ? 0.0 : 0.0,
          0)
        ..scale(isDrawerOpen ? 0.90 : 1.00)
        ..rotateZ(isDrawerOpen
            ? arabic
                ? 0.1
                : -0.1
            : 0),
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () => logoPressed(),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Image.asset(
              'assets/images/home-logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
