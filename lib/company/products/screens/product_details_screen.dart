import 'package:future_hub/common/shared/models/products.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/common/shared/widgets/price_text.dart';
import 'package:future_hub/company/products/widgets/change_public_price_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String id;
  final CompanyProduct product;
  final bool company;

  const ProductDetailsScreen(
    this.id, {
    required this.product,
    this.company = true,
    super.key,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  void _changePublicPrice(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ChangePublicPriceBottomSheet(
          originalPrice: widget.product.price,
          publicPrice: widget.product.companyPrice!,
          productId: widget.id,
        );
      },
    );
  }

  int qunatity = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: FutureHubAppBar(
        title: Text(
          t.product_details,
          style: const TextStyle(
            color: Palette.blackColor,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        context: context,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/product-back-1.png',
                        height: MediaQuery.sizeOf(context).height * 0.4,
                      ),
                      Image.asset(
                        'assets/icons/product-back-2.png',
                        height: MediaQuery.sizeOf(context).height * 0.37,
                      ),
                      AspectRatio(
                        aspectRatio: 7 / 5,
                        child: Image.network(
                          widget.product.imagePath ??
                              'https://i5.walmartimages.com/asr/462c1ae6-966c-4652-b93e-8559e992d45b.031cacbaeeac39e5a5aaee89579a5e73.jpeg',
                          // fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.title,
                        style:
                            theme.textTheme.titleLarge!.copyWith(fontSize: 30),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                // if(qunatity <= widget.product){}
                                setState(() {
                                  qunatity += 1;
                                });
                              },
                              child: SvgPicture.asset('assets/icons/plus.svg')),
                          const SizedBox(width: 20.0),
                          Text(
                            qunatity.toString(),
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Palette.blackColor),
                          ),
                          const SizedBox(width: 20.0),
                          InkWell(
                            onTap: () {
                              if (qunatity > 0) {
                                setState(() {
                                  qunatity -= 1;
                                });
                              }
                            },
                            child: SvgPicture.asset(
                              'assets/icons/minus.svg',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: widget.company
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  children: [
                    if (widget.company)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PriceText(
                            price: widget.product.companyPrice ?? 0,
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            t.original_price,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     PriceText(price: widget.product.price),
                    //     const SizedBox(height: 5.0),
                    //     Text(
                    //       widget.company ? t.public_price : t.price,
                    //       style: theme.textTheme.bodySmall,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                // TODO CHANGE COMPANY PRODUCT PRICE
                if (widget.company) ...[
                  const Divider(height: 32.0),
                  ChevronButton(
                    onPressed: () => _changePublicPrice(context),
                    dense: true,
                    style: ChevronButtonStyle.text(Palette.primaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/ticket.svg'),
                        const SizedBox(width: 8.0),
                        Text(t.change_public_price),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text(
                //   t.product_details,
                //   style: theme.textTheme.titleLarge,
                // ),
                const SizedBox(height: 16.0),
                Text(
                  widget.product.description ?? "",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 25,
                    color: const Color.fromRGBO(6, 23, 55, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
