import 'package:sleepfy/controllers/dio_controller.dart';
import 'package:sleepfy/models/response_model.dart';
import 'package:sleepfy/models/user_model.dart';

class UserController {
  static Future<UserModel?> login(Map<String, dynamic> data) async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.post, 'auth/login/', data: data);

    if (resp.status == 200) return UserModel.fromJson(resp.data);

    return null;
  }

  static Future<UserModel?> register(Map<String, String> data) async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.post, 'auth/register', data: data);

    if (resp.status == 201) return UserModel.fromJson(resp.data);

    return null;
  }
}
