import 'package:future_hub/common/shared/models/order_model.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
// import 'package:future_hub/common/shared/widgets/flutter_toast.dart';
import 'package:future_hub/common/shared/widgets/order_card_item.dart';
import 'package:future_hub/employee/orders/cubit/order_cubit.dart';
import 'package:future_hub/employee/orders/cubit/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/activate_order_bottom_sheet.dart';

class EmployeeOrderDetailsScreen extends StatefulWidget {
  const EmployeeOrderDetailsScreen({
    this.showActivate = false,
    required this.order,
    super.key,
  });

  final Order order;
  final bool showActivate;

  @override
  State<EmployeeOrderDetailsScreen> createState() =>
      _EmployeeOrderDetailsScreenState();
}

class _EmployeeOrderDetailsScreenState
    extends State<EmployeeOrderDetailsScreen> {
  // final _couponController = TextEditingController();
  // bool _loading = false;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Future<void> _validCoupon() async {
  //   _formKey.currentState!.save();
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _loading = true;
  //     });
  //     final result = await context
  //         .read<OrderCubit>()
  //         .validateOrder(context, coupon: _couponController.text);
  //     if (result.runtimeType == String) {
  //       setState(() {
  //         _loading = false;
  //       });
  //       showToast(text: result, state: ToastStates.error);
  //     }
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }

  void _activateOrder(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => const ActivateOrderBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {},
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        // print(widget.showActivate.toString());
        return Scaffold(
          appBar: FutureHubAppBar(
            title: Text(
              t.order_details,
              style: const TextStyle(
                color: Palette.blackColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            context: context,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.08,
                      width: size.width * 0.17,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.network(
                        widget.order.user!.imageURL!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.04,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.user!.name ?? '',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 23,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text('#${(context.read<OrderCubit>().state as OrderCreatedState).referenceNumber}',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Palette.textGreyColor,
                                height: 1)),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: t.products,
                        style:
                            theme.textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                      TextSpan(
                        text:
                            "    (${t.count_products(widget.order.products!.length)})",
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontSize: 12,
                          color: Palette.primaryLightColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                // OrderCard(
                //   showUser: false,
                //   showTotal: true,
                //   summary: false,
                //   order: widget.order,
                // ),
                const SizedBox(height: 50.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.order.products!.length,
                    itemBuilder: (context, index) {
                      return OrderCardItem(
                        product: widget.order.products![index],
                      );
                    },
                  ),
                ),
                // if (widget.showActivate &&
                //     (state.totalDiscount == null || state.totalDiscount == 0.0))
                //   Form(
                //     key: _formKey,
                //     child: Row(
                //       children: [
                //         Expanded(
                //           flex: 3,
                //           child: ChevronLabeledTextField(
                //             controller: _couponController,
                //             label: t.enter_coupon_code,
                //             validator: (String? s) {
                //               if (s!.isEmpty) {
                //                 return t.add_couppn_first;
                //               } else {
                //                 return null;
                //               }
                //             },
                //           ),
                //         ),
                //         Expanded(
                //           flex: 1,
                //           child: ChevronButton(
                //             onPressed: _validCoupon,
                //             loading: _loading,
                //             child: Text(t.next),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // PuncherCard(
                //   showDirection: order.status == 0,
                //   puncher: order.puncher,
                // ),
                const Spacer(),
                if (widget.showActivate)
                  SizedBox(
                    width: size.width,
                    child: ChevronButton(
                      onPressed: () => _activateOrder(context),
                      child: Text(
                        t.finish_the_order,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
