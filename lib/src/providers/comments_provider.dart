import 'package:flutter/material.dart';
import 'package:sleepfy/controllers/comments_controller.dart';
import 'package:sleepfy/models/comment_model.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';

class CommentsProvider extends ChangeNotifier {
  List<CommentModel> comments = [];

  final TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  bool loadingSendMsg = false;
  bool loadingGetMsgs = false;

  CommentsProvider() {
    init();
  }

  Future<void> init() async {
    loadingGetMsgs = true;
    notifyListeners();

    comments = await CommentsController.getAllTest();

    loadingGetMsgs = false;
    notifyListeners();
  }

  Future<void> addComment() async {
    final String text = _controller.text;

    if (text.isEmpty) return MySnackBar.showSnackBarError('El comentario no puede estar vacío');

    loadingSendMsg = true;
    notifyListeners();

    final CommentModel? comment = await CommentsController.sendComment({
      'comment': text,
      'userId': UserPreferences.id,
    });

    if (comment == null) {
      loadingSendMsg = false;
      notifyListeners();
    } else {
      comments.add(comment);

      _controller.clear();
      loadingSendMsg = false;

      MySnackBar.showSnackBarSuccess('Comentario enviado');

      notifyListeners();
    }
  }
}
