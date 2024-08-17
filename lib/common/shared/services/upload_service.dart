import 'dart:io';
import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/shared/utils/fetch_exception.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' show MultipartFile;

class UploadService {
  static const mutation = r'''
    mutation Upload($file: Upload!) {
      upload(file: $file)
    }
  ''';

  Future<String> upload({required File file}) async {
    final toUpload = await MultipartFile.fromPath('', file.path);

    final result = await Client.current.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {'file': toUpload},
      ),
    );

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    final data = result.data!['upload'] as String;

    debugPrint(data);

    return data;
  }
}
