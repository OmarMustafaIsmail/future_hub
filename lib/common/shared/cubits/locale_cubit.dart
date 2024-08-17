import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/shared/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(CacheManager.locale);

  changeLocale(Locale locale) {
    CacheManager.changeLocale(locale.languageCode);
    Client.changeLanguage(locale.languageCode);

    emit(locale);
  }
}
