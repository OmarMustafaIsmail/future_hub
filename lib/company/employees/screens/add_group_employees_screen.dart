import 'dart:io';

import 'package:future_hub/common/info/cubit/info_cubit.dart';
import 'package:future_hub/common/info/cubit/info_state.dart';
import 'package:future_hub/common/shared/constants.dart';
import 'package:future_hub/common/shared/services/upload_service.dart';
import 'package:future_hub/common/shared/utils/run_fetch.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:future_hub/common/shared/widgets/chevron_button.dart';
import 'package:future_hub/common/shared/widgets/chevron_dashed_border.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/company/employees/cubit/employees_cubit.dart';
import 'package:future_hub/company/employees/cubit/employees_state.dart';
import 'package:future_hub/company/employees/services/employees_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:future_hub/common/shared/widgets/flutter_toast.dart';

class AddGroupEmployees extends StatefulWidget {
  const AddGroupEmployees({super.key});

  @override
  State<AddGroupEmployees> createState() => _AddGroupEmployeesState();
}

class _AddGroupEmployeesState extends State<AddGroupEmployees> {
  File? _employeesFile;
  var _uploading = false;
  final _uploadService = UploadService();
  final _employeesService = EmployeesService();
  String text = '';
  String fileUrl = '';

  Future<void> _pickEmployeesFile() async {
    final pickedFile = await FilePicker.platform.pickFiles();
    _employeesFile = File(pickedFile!.files.single.path!);
    setState(() {
      text = pickedFile.files.single.path!.split('/').last;
    });
    if (!mounted) return;
    runFetch(
      context: context,
      fetch: () async {
        fileUrl = await _uploadService.upload(file: _employeesFile!);
        debugPrint('$baseURL/$fileUrl');
      },
      after: () {
        setState(() => _uploading = false);
      },
    );
  }

  Future<void> _uploadEmployeesFile() async {
    setState(() {
      _uploading = true;
    });
    if (!mounted) return;
    runFetch(
      context: context,
      fetch: () async {
        await _employeesService.addEmployeeFile(file: '$baseURL/$fileUrl');
      },
      after: () {
        setState(() => _uploading = false);
      },
    );
  }

  Future<void> _downloadDataFilingFile() async {
    final t = AppLocalizations.of(context)!;

    try {
      final state = context.read<InfoCubit>().state as InfoLoaded;
      final url = Uri.parse(state.info.excelUserUploadExample!);
      await launchUrl(url, mode: LaunchMode.platformDefault);
    } catch (e) {
      debugPrint(e.toString());

      if (e is! PlatformException) {
        showToast(
          text: t.couldnt_find_the_data_filling_file_try_again_later,
          state: ToastStates.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocConsumer<EmployeesCubit, EmployeesState>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: FutureHubAppBar(
          title: Text(t.add_a_group),
          context: context,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t.data_filling_file,
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 16.0),
              ChevronDashedBorder(
                child: ChevronButton(
                  onPressed: _downloadDataFilingFile,
                  style: ChevronButtonStyle.dashed(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/download.svg'),
                      const SizedBox(width: 12.0),
                      Text(t.download_file),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                t.upload_data_filling_file,
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 16.0),
              ChevronDashedBorder(
                color: Palette.successColor,
                child: ChevronButton(
                  onPressed: _pickEmployeesFile,
                  style: ChevronButtonStyle.dashed(color: Palette.successColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/excel.svg'),
                      const SizedBox(width: 12.0),
                      Text(text.isEmpty ? t.add_file : text),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Spacer(),
              ChevronButton(
                loading: _uploading,
                onPressed: _uploadEmployeesFile,
                child: Text(t.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
