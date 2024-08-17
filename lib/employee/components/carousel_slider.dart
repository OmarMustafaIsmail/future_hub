import 'package:carousel_slider/carousel_slider.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class EmployeeHomeCarousel extends StatefulWidget {
  const EmployeeHomeCarousel({required this.isDrawerOpen, super.key});
  final bool isDrawerOpen;

  @override
  State<EmployeeHomeCarousel> createState() => _EmployeeHomeCarouselState();
}

class _EmployeeHomeCarouselState extends State<EmployeeHomeCarousel> {
  List<Widget> images = [
    ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.asset(
        'assets/images/banner.png',
        fit: BoxFit.contain,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.asset(
        'assets/images/banner.png',
        fit: BoxFit.contain,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.asset(
        'assets/images/banner.png',
        fit: BoxFit.contain,
      ),
    )
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: CarouselSlider(
            options: CarouselOptions(
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              clipBehavior: Clip.hardEdge,
              viewportFraction: 0.82,
              enlargeFactor: 0.3,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 10),
              onPageChanged: (index, reason) {
                setState(() {
                  this.index = index;
                });
              },
            ),
            items: images,
          ),
        ),
        Transform.translate(
          offset: Offset(0, -MediaQuery.of(context).size.height * 0.04),
          child: DotsIndicator(
            decorator: DotsDecorator(
                color: const Color.fromRGBO(0, 93, 163, 0.1),
                spacing: const EdgeInsets.all(1),
                activeColor: Palette.primaryColor,
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                activeSize: const Size(25.0, 9.0),
                size: const Size(11, 8)),
            dotsCount: images.length,
            position: index,
          ),
        )
      ],
    );
  }
}
