import 'package:future_hub/common/shared/utils/fetch_exception.dart';
import 'package:future_hub/common/shared/widgets/flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnValidation = void Function(Map<String, String> validation);

Future<T?> runFetch<T>({
  required BuildContext context,
  required Future<T> Function() fetch,
  OnValidation? onValidation,
  void Function()? after,
}) async {
  final t = AppLocalizations.of(context)!;

  try {
    return await fetch();
  } catch (exception) {
    final isFetch = exception is FetchException;

    if (isFetch && exception.isValidation && onValidation != null) {
      onValidation(exception.validation);
    } else {
      final message = isFetch ? exception.message : t.something_went_wrong;

      showToast(text: message, state: ToastStates.error);
    }
  } finally {
    if (after != null) {
      after();
    }
  }

  return null;
}
