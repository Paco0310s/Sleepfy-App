import 'package:sleepfy/controllers/dio_controller.dart';
import 'package:sleepfy/models/admin_models.dart';
import 'package:sleepfy/models/response_model.dart';

class AdminController {
  static Future<AdminMetricsModel?> getMetrics() async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.get,
      'admin/metrics',
      showLoading: false,
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return AdminMetricsModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<List<AdminUserModel>> listUsers({String? search}) async {
    final trimmed = search?.trim() ?? '';
    final query = trimmed.isNotEmpty ? '?search=${Uri.encodeQueryComponent(trimmed)}' : '';
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.get,
      'admin/users$query',
      showLoading: false,
    );

    if (resp.status == 200 && resp.data is List) {
      return (resp.data as List)
          .whereType<Map<String, dynamic>>()
          .map(AdminUserModel.fromJson)
          .toList();
    }
    return [];
  }

  static Future<AdminUserModel?> toggleUserAdmin(int userId, bool isAdmin) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.patch,
      'admin/users/$userId/admin',
      data: {'isAdmin': isAdmin},
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return AdminUserModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<AdminVerificationCodeModel?> getUserVerificationCode(int userId) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.get,
      'admin/users/$userId/verification-code',
      showLoading: true,
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return AdminVerificationCodeModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<AdminVerificationCodeModel?> generateUserVerificationCode(int userId) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.post,
      'admin/users/$userId/verification-code',
    );

    if ((resp.status == 200 || resp.status == 201) && resp.data is Map<String, dynamic>) {
      return AdminVerificationCodeModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<bool> verifyUserEmail(int userId) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.patch,
      'admin/users/$userId/verify-email',
    );
    return resp.status == 200;
  }

  static Future<bool> changeUserPassword(int userId, String newPassword) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.patch,
      'admin/users/$userId/password',
      data: {'newPassword': newPassword},
    );
    return resp.status == 200;
  }

  static Future<bool> clearUserSessions(int userId) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.delete,
      'admin/users/$userId/sessions',
    );
    return resp.status == 200;
  }

  static Future<bool> deleteUser(int userId) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.delete,
      'admin/users/$userId',
    );
    return resp.status == 200;
  }

  static Future<AdminUserModel?> updateUser(
    int userId, {
    required String name,
    required String lastName,
    required String email,
  }) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.patch,
      'admin/users/$userId',
      data: {
        'name': name.trim(),
        'lastName': lastName.trim(),
        'email': email.trim(),
      },
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return AdminUserModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<AdminTestModel?> getLatestTest() async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.get,
      'admin/test',
      showLoading: false,
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return AdminTestModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<AdminQuestionModel?> createQuestion(
    String question,
    List<Map<String, dynamic>> options,
  ) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.post,
      'admin/test/questions',
      data: {
        'question': question,
        'options': options,
      },
    );

    if ((resp.status == 201 || resp.status == 200) && resp.data is Map<String, dynamic>) {
      return AdminQuestionModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<AdminQuestionModel?> updateQuestion(
    int questionId,
    String question,
    List<Map<String, dynamic>> options,
  ) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.patch,
      'admin/test/questions/$questionId',
      data: {
        'question': question,
        'options': options,
      },
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return AdminQuestionModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<bool> deleteQuestion(int questionId) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.delete,
      'admin/test/questions/$questionId',
    );
    return resp.status == 200;
  }

  static Future<bool> deleteComment(int commentId) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.delete,
      'admin/comments/$commentId',
    );
    return resp.status == 200;
  }
}
