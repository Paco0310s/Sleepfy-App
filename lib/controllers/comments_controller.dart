import 'package:sleepfy/controllers/dio_controller.dart';
import 'package:sleepfy/models/comment_model.dart';
import 'package:sleepfy/models/response_model.dart';

class CommentsController {
  static Future<List<CommentModel>> getAllTest() async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.get, 'comments', showLoading: false);

    if (resp.status == 200) {
      final List<CommentModel> comments = [];

      for (final Map<String, dynamic> item in resp.data['comments']) {
        comments.add(CommentModel.fromJson(item));
      }

      return comments;
    }

    return [];
  }

  static Future<CommentModel?> sendComment(Map<String, dynamic> data) async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.post, 'comments', data: data, showLoading: false);

    if (resp.status == 201) {
      return CommentModel.fromJson(resp.data['comment']);
    }

    return null;
  }
}
