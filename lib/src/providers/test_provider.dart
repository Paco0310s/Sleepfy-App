import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepfy/controllers/test_controller.dart';
import 'package:sleepfy/models/answer_options_model.dart';
import 'package:sleepfy/models/response_model.dart';
import 'package:sleepfy/models/test_model.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/home_view.dart';

class TestProvider extends ChangeNotifier {
  TestModel? test;
  List<Set<int>> answers = [];
  bool isLoading = false;
  AnswersOption? selectedAnswer;
  bool testFinished = false;
  String? routine;

  TestProvider() {
    init();
  }

  Future<void> init() async {
    isLoading = true;
    testFinished = false;
    routine = null;
    notifyListeners();

    final ResponseModel resp = await TestController.hasRoutine();
    final String? routineResp = resp.data['routine'];

    if (routineResp != null) {
      testFinished = true;
      routine = routineResp;
    } else {
      await getAllTest();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getAllTest() async {
    test = await TestController.getAllTest();
  }

  void setSelectedAnswer(AnswersOption answer) {
    selectedAnswer = answer;
    notifyListeners();
  }

  void addAnswer(int questionId, int answerId) async {
    answers.add({questionId, answerId});

    if (answers.length == test!.questions.length) {
      testFinished = true;
      await sendAnswers();
    }

    selectedAnswer = null;
    notifyListeners();
  }

  Future<void> sendAnswers() async {
    final ResponseModel resp = await TestController.sendAnswers({
      'answers': answers.map((e) => {'question_id': e.first, 'answer_id': e.last}).toList(),
      'test_id': test!.id,
      'user_id': UserPreferences.id,
    });

    if (resp.status == 201) {
      MySnackBar.showSnackBarSuccess('Respuestas enviadas correctamente');
      routine = resp.data['routine'];
      toGoHome();
    }
  }

  void toGoHome() {
    Get.to(() => const HomeView());
  }
}
