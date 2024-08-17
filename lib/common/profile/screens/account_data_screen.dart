import 'dart:io';

import 'package:future_hub/common/auth/cubit/auth_cubit.dart';
import 'package:future_hub/common/auth/cubit/auth_state.dart';
import 'package:future_hub/common/profile/shared/constants.dart';
import 'package:future_hub/common/profile/widgets/account_data_tab_bar_item.dart';
import 'package:future_hub/common/profile/widgets/account_data_tab_content.dart';
import 'package:future_hub/common/profile/widgets/company_data_tab_content.dart';
import 'package:future_hub/common/profile/widgets/company_files_tab_content.dart';
import 'package:future_hub/common/profile/widgets/profile_picture_update.dart';
import 'package:future_hub/common/shared/constants.dart';
import 'package:future_hub/common/shared/palette.dart';
import 'package:future_hub/common/shared/services/upload_service.dart';
import 'package:future_hub/common/shared/utils/run_fetch.dart';
import 'package:future_hub/common/shared/widgets/chevron_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountDataScreen extends StatefulWidget {
  const AccountDataScreen({super.key});

  @override
  State<AccountDataScreen> createState() => _AccountDataScreenState();
}

class _AccountDataScreenState extends State<AccountDataScreen> {
  final _showTabs = false;

  var _activeTab = AccountDataTab.accountData;
  final _uploadService = UploadService();

  ImageProvider? _profilePicture;
  File? _updatedProfilePicture;
  var _uploading = false;

  @override
  void initState() {
    super.initState();

    final state = context.read<AuthCubit>().state;
    final image = (state as AuthSignedIn).user.imageURL;
    if (image != null) {
      _profilePicture = NetworkImage(image);
    }
  }

  void _changeTab(AccountDataTab tab) {
    setState(() {
      _activeTab = tab;
    });
  }

  Future<void> _updateProfilePicture() async {
    final picker = ImagePicker();
    // TODO: add support for camera
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    _updatedProfilePicture = File(image.path);
    setState(() {
      _profilePicture = FileImage(_updatedProfilePicture!);
    });

    if (!mounted) return;

    runFetch(
      context: context,
      fetch: () async {
        setState(() => _uploading = true);

        final imageURL =
            await _uploadService.upload(file: _updatedProfilePicture!);

        debugPrint(imageURL);

        if (context.mounted) {
          // ignore: use_build_context_synchronously
          await context.read<AuthCubit>().updateProfilePhoto(
                // ignore: use_build_context_synchronously
                context: context,
                image: '$baseURL/$imageURL',
              );
        }
      },
      after: () {
        setState(() => _uploading = false);
      },
    );
  }

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _activeTab != AccountDataTab.accountData
          ? FutureHubAppBar(
              title: Text(t.account_data),
              context: context,
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                toolbarHeight: 0,
              ),
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSignedIn) {
              return Column(
                children: [
                  if (_activeTab == AccountDataTab.accountData) ...[
                    Transform.translate(
                      offset: const Offset(0, -10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEdit = !isEdit;
                              });
                            },
                            child: isEdit
                                ? Text(
                                    t.save,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Palette.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/edit-new.png',
                                    height: 20,
                                  ),
                          ),
                          Text(
                            t.basic_information,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Palette.blackColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Palette.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 30.0),
                  Center(
                    child: UpdateProfilePicture(
                      loading: _uploading,
                      onPressed: _updateProfilePicture,
                      image: _profilePicture,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  if (_showTabs && state.user.type == 'company')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 20,
                        ),
                        color: Palette.primaryColor.withOpacity(0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AccountDataTabBarItem(
                              onPressed: () =>
                                  _changeTab(AccountDataTab.companyData),
                              name: t.company_data,
                              iconPath: 'assets/icons/company-data.svg',
                              active: _activeTab == AccountDataTab.companyData,
                            ),
                            AccountDataTabBarItem(
                              onPressed: () =>
                                  _changeTab(AccountDataTab.companyFiles),
                              name: t.company_files,
                              iconPath: 'assets/icons/company-files.svg',
                              active: _activeTab == AccountDataTab.companyFiles,
                            ),
                            AccountDataTabBarItem(
                              onPressed: () =>
                                  _changeTab(AccountDataTab.accountData),
                              name: t.account_data,
                              iconPath: 'assets/icons/person.svg',
                              active: _activeTab == AccountDataTab.accountData,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_activeTab == AccountDataTab.accountData)
                    AccountDataTabContent(
                      enabled: isEdit,
                    )
                  else if (_activeTab == AccountDataTab.companyData)
                    const CompanyDataTabContent()
                  else if (_activeTab == AccountDataTab.companyFiles)
                    const CompanyFilesTabContent(),
                ],
              );
            }

            // TODO: Add shimmer
            return Container();
          },
        ),
      ),
    );
  }
}
