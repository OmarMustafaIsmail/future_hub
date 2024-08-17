import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/info/graphql/info.gql.dart';
import 'package:future_hub/common/info/models/info_model.dart';
import 'package:future_hub/common/info/models/question_model.dart';
import 'package:future_hub/common/shared/utils/fetch_exception.dart';
import 'package:flutter/cupertino.dart';

class InfoService {
  Future<Info> getInfo() async {
    final result = await Client.current.queryInfo();
    final about = result.parsedData?.aboutUs;
    final questions = result.parsedData?.questions;

    if (result.hasException) {
      debugPrint(result.exception.toString());
      throw FetchException.fromOperation(result.exception!);
    }

    List<Question> questions0 = questions!.data
        .map((e) =>
            Question(id: e.id, title: e.title, description: e.description!))
        .toList();

    return Info(
      about: about!.about ?? "",
      terms: about.terms_condition ?? "",
      questions: questions0,
      privacy: about.privacy ?? "",
      phone: about.phone.toString(),
      email: about.email ?? "",
      excelUserUploadExample: about.excel_user_upload_example,
      imagePath: about.imagePath ?? "",
    );
  }
}
