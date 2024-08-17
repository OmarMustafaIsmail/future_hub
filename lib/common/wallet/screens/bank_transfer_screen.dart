import 'dart:io';

import 'package:future_hub/common/graphql/schema.gql.dart';
import 'package:future_hub/common/shared/cubits/wallet_cubit/wallet_cubit.dart';
import 'package:future_hub/common/shared/services/upload_service.dart';
import 'package:future_hub/common/shared/utils/run_fetch.dart';
import 'package:future_hub/common/shared/utils/validator.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/common/shared/widgets/chevron_labled_text_field.dart';
import 'package:future_hub/common/shared/widgets/flutter_toast.dart';
import 'package:future_hub/common/wallet/services/wallet_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/palette.dart';
import '../../shared/widgets/chevron_bottom_sheet.dart';
import '../../shared/widgets/chevron_dashed_border.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({required this.isBank, required this.title, super.key});

  final String title;
  final bool isBank;

  @override
  State<PaymentScreen> createState() => _BankTransferScreen();
}

class _BankTransferScreen extends State<PaymentScreen> {
  bool _loading = false;
  final _walletService = WalletService();
  final _uploadService = UploadService();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final Map<String, String> _validation = {};

  void _onActivate() async {
    if (widget.isBank) {
      await runFetch(
        context: context,
        fetch: () async {
          setState(() {
            _loading = true;
          });

          String? attachment;

          if (image != null) {
            attachment = await _uploadService.upload(
              file: File(image!.path),
            );

            debugPrint(attachment);
          }

          await _walletService.addBalanceToCompany(
            title: _titleController.text,
            amount: double.parse(_amountController.text),
            attachment: attachment,
            paymentMethod: EnumPaymentMethod.BANK_TRANSFER,
          );

          if (!mounted) return;
          final t = AppLocalizations.of(context)!;
          showToast(
            text: t.amount_added_successfully,
            state: ToastStates.success,
          );
          WalletCubit.get(context).update(context);

          context.go('/company');
        },
        after: () async {
          setState(() {
            _loading = false;
          });
        },
      );
    } else {
      // TODO: implement TAPS
      debugPrint("PAY TAPS");
    }
  }

  XFile? image;

  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  void _selectImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => addEmployeesBottomSheet(context),
    );
  }

  Widget addEmployeesBottomSheet(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return ChevronBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 5.0,
          ),
          Center(
            child: Text(
              t.please_choose_media_to_select,
              style: theme.textTheme.titleLarge!.copyWith(
                color: Palette.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ChevronButton(
            onPressed: () {
              Navigator.pop(context);
              getImage(ImageSource.gallery);
            },
            child: Text(t.from_gallery),
          ),
          const SizedBox(
            height: 10,
          ),
          ChevronButton(
            onPressed: () {
              Navigator.pop(context);
              getImage(ImageSource.camera);
            },
            child: Text(t.from_camera),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: FutureHubAppBar(
        title: Text(widget.title),
        context: context,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.isBank)
                          ChevronLabeledTextField(
                            controller: _titleController,
                            label: t.title,
                            hintText: t.enter_the_title,
                            icon: const Icon(Icons.content_paste),
                            keyboardType: TextInputType.text,
                            onChanged: (value) =>
                                _validation.remove('input.name'),
                            validator: (value) {
                              return Validator(value)
                                  .custom((value) => _validation['input.name'])
                                  .mandatory(t.this_field_is_required)
                                  .error;
                            },
                          ),
                        SizedBox(height: widget.isBank ? 24.0 : 150),
                        ChevronLabeledTextField(
                          controller: _amountController,
                          label: t.the_amount,
                          hintText: t.enter_the_amount,
                          icon: SvgPicture.asset('assets/icons/wallet.svg'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              _validation.remove('input.email'),
                          validator: (value) {
                            return Validator(value)
                                .custom((value) => _validation['input.email'])
                                .mandatory(t.this_field_is_required)
                                .error;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        image != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    //to show image, you type like this.
                                    File(image!.path),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 24.0),
                        if (widget.isBank)
                          ChevronDashedBorder(
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: ChevronButton(
                                onPressed: () {
                                  _selectImage(context);
                                },
                                style: ChevronButtonStyle.dashed(),
                                child: Text(t.transfer_image),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24.0),
                        const Spacer(),
                        ChevronButton(
                          onPressed: _onActivate,
                          loading: _loading,
                          child: Text(t.confirm_payment),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
