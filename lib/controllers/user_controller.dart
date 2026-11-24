import 'package:sleepfy/controllers/dio_controller.dart';
import 'package:sleepfy/models/response_model.dart';
import 'package:sleepfy/models/user_model.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';

class UserController {
  static Future<ResponseModel> loginRaw(Map<String, dynamic> data) async {
    return await DioController.petition(HTTPMethods.post, 'auth/login/', data: data);
  }

  static Future<ResponseModel> registerRaw(Map<String, String> data) async {
    return await DioController.petition(HTTPMethods.post, 'auth/register', data: data);
  }

  static Future<UserModel?> verifyEmail(String email, String code) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.post,
      'auth/verify-email',
      data: {'email': email.trim(), 'code': code.trim()},
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic> && resp.data['token'] != null) {
      return UserModel.fromJson(resp.data);
    }
    return null;
  }

  static Future<bool> resendVerification(String email) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.post,
      'auth/resend-verification',
      data: {'email': email.trim()},
    );
    return resp.status == 200;
  }

  static Future<bool> forgotPassword(String email) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.post,
      'auth/forgot-password',
      data: {'email': email.trim()},
    );
    return resp.status == 200;
  }

  static Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.post,
      'auth/reset-password',
      data: {
        'email': email.trim(),
        'code': code.trim(),
        'newPassword': newPassword,
      },
    );
    return resp.status == 200;
  }

  static Future<bool> refreshProfile() async {
    if (UserPreferences.token == null || UserPreferences.token!.isEmpty) return false;
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.get,
      'auth/me',
      showLoading: false,
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      final user = UserModel.fromJson(resp.data as Map<String, dynamic>);
      await UserPreferences.setName(user.name);
      await UserPreferences.setLastName(user.lastName);
      await UserPreferences.setEmail(user.email);
      await UserPreferences.setIsAdmin(user.isAdmin);
      return true;
    }
    return false;
  }

  static Future<void> logoutRemote() async {
    final refreshToken = UserPreferences.refreshToken;
    await DioController.petition(
      HTTPMethods.post,
      'auth/logout',
      data: (refreshToken != null && refreshToken.isNotEmpty)
          ? {'refreshToken': refreshToken}
          : <String, dynamic>{},
      showLoading: false,
    );
  }

  static Future<bool> updateProfile({
    required String name,
    required String lastName,
  }) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.patch,
      'auth/me',
      data: {
        'name': name.trim(),
        'lastName': lastName.trim(),
      },
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      final user = UserModel.fromJson(resp.data as Map<String, dynamic>);
      await UserPreferences.setName(user.name);
      await UserPreferences.setLastName(user.lastName);
      return true;
    }
    return false;
  }

  static Future<bool> deleteAccount() async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.delete,
      'auth/me',
    );
    return resp.status == 200;
  }
}
