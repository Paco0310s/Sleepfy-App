import 'package:sleepfy/controllers/dio_controller.dart';
import 'package:sleepfy/models/response_model.dart';
import 'package:sleepfy/models/test_model.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';

class TestController {
  static Future<TestModel?> getAllTest() async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.get, 'questions/all/1', showLoading: false);

    if (resp.status == 200) return TestModel.fromJson(resp.data);

    return null;
  }

  static Future<ResponseModel> sendAnswers(Map<String, dynamic> data) async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.post, 'user-answers', data: data);

    return resp;
  }

  static Future<ResponseModel> hasRoutine() async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.get, 'custom-routine/user/${UserPreferences.id}}', showLoading: false);

    return resp;
  }
}
