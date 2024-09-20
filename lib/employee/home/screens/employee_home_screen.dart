import 'package:future_hub/common/shared/utils/cache_manager.dart';
import 'package:future_hub/common/shared/widgets/drawer_screen.dart';
import 'package:future_hub/employee/components/best_car_oil_widget.dart';
import 'package:future_hub/employee/components/bottom_nav_bar.dart';
import 'package:future_hub/employee/components/carousel_slider.dart';
import 'package:future_hub/common/shared/widgets/home_app_bar.dart';
import 'package:future_hub/employee/components/home_wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class EmployeeHomeScreen extends StatefulWidget {
  final void Function() onTapBalance;

  const EmployeeHomeScreen({
    super.key,
    required this.onTapBalance,
  });

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
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
    // MediaQuery.of(context).size.height * 0.6;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool arabic = Directionality.of(context) == TextDirection.rtl;

    final paddingTop = MediaQuery.of(context).padding.top;
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeAppBar(
                      icon: GestureDetector(
                        onTap: () => setState(() {
                          isDrawerOpen = !isDrawerOpen;
                        }),
                        child: SvgPicture.asset(
                          isDrawerOpen
                              ? 'assets/icons/close.svg'
                              : 'assets/icons/drawer.svg',
                          height: isDrawerOpen ? 40 : 20,
                        ),
                      ),
                    ),
                    EmployeeHomeCarousel(isDrawerOpen: isDrawerOpen),
                    Transform.translate(
                        offset: Offset(
                            0, -MediaQuery.of(context).size.height * 0.02),
                        child: const EmployeeHomeWalletCard()),
                    const BestCarOilCard(),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     left: 24.0,
                    //     right: 24.0,
                    //     bottom: 18.0,
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.stretch,
                    //     children: [
                    //       ChevronButton(
                    //         child: Text(t.new_order),
                    //         onPressed: () =>
                    //             context.push('/employee/new-order'),
                    //       ),
                    //       const SizedBox(height: 20.0),
                    //       ChevronDashedBorder(
                    //         child: SizedBox(
                    //           width: MediaQuery.sizeOf(context).width,
                    //           child: ChevronButton(
                    //             onPressed: () =>
                    //                 context.push('/employee/oil/search'),
                    //             style: ChevronButtonStyle.dashed(),
                    //             child: Text(t.best_oil_for_your_car),
                    //           ),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(
                    //           top: 18.0,
                    //         ),
                    //         child: Text(
                    //           t.previous_orders,
                    //           style: theme.textTheme.titleLarge,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
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
      child: const EmployeeBottomNavBar(),
    );
  }

  Widget buildCenterLogo(BuildContext context, bool arabic) {
    logoPressed() {
      if (showHint) {
        CacheManager.saveData('home-hint', 'true');
        setState(() {
          showHint = false;
        });
        context.push('/employee/new-order');
        return;
      }
      context.push('/employee/new-order');
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
