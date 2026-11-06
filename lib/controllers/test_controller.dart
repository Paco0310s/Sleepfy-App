import 'package:sleepfy/controllers/dio_controller.dart';
import 'package:sleepfy/models/response_model.dart';
import 'package:sleepfy/models/test_model.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';

class TestController {
  static Future<TestModel?> getAllTest() async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.get, 'questions/latest', showLoading: false);

    if (resp.status == 200 && resp.data != null) return TestModel.fromJson(resp.data);

    // Fallback a test 1 si es necesario
    final ResponseModel fallback = await DioController.petition(HTTPMethods.get, 'questions/all/1', showLoading: false);
    if (fallback.status == 200 && fallback.data != null) return TestModel.fromJson(fallback.data);

    return null;
  }

  static Future<ResponseModel> sendAnswers(Map<String, dynamic> data) async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.post, 'user-answers', data: data);

    return resp;
  }

  static Future<ResponseModel> hasRoutine() async {
    if (UserPreferences.id == null) {
      return ResponseModel(message: 'No user session', data: {}, status: 400);
    }
    final ResponseModel resp = await DioController.petition(HTTPMethods.get, 'custom-routine/user/${UserPreferences.id}', showLoading: false);

    return resp;
  }

  static Future<List<dynamic>> getRoutineHistory() async {
    if (UserPreferences.id == null) return [];
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.get,
      'custom-routine/user/${UserPreferences.id}/history',
      showLoading: false,
    );

    if (resp.status == 200 && resp.data is List) {
      return resp.data as List<dynamic>;
    }

    return [];
  }

  static Future<String?> sendChatMessage(String message, List<Map<String, String>> history) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.post,
      'custom-routine/chat',
      data: {
        'userId': UserPreferences.id ?? 0,
        'message': message,
        'history': history,
      },
      showLoading: false,
    );

    if ((resp.status == 200 || resp.status == 201) && resp.data is Map && resp.data['reply'] != null) {
      return resp.data['reply'].toString();
    }

    return null;
  }
}
