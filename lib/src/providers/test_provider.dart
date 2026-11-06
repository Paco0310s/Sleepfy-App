import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepfy/controllers/test_controller.dart';
import 'package:sleepfy/models/answer_options_model.dart';
import 'package:sleepfy/models/response_model.dart';
import 'package:sleepfy/models/routine_history_model.dart';
import 'package:sleepfy/models/test_model.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/home_view.dart';
import 'package:sleepfy/src/views/test_view.dart';

class TestProvider extends ChangeNotifier {
  TestModel? test;
  List<Set<int>> answers = [];
  bool isLoading = false;
  AnswersOption? selectedAnswer;
  bool testFinished = false;
  String? routine;
  bool isOffline = false;
  String? cachedRoutineDate;
  List<RoutineHistoryModel> routineHistory = [];
  bool isLoadingHistory = false;
  bool isRetaking = false;

  TestProvider() {
    init();
  }

  Future<void> init() async {
    isLoading = true;
    isOffline = false;

    // 1. Cargar inmediatamente desde almacenamiento local si existe (experiencia offline instantánea)
    final String? cached = UserPreferences.routine;
    routine = cached;
    cachedRoutineDate = UserPreferences.routineDate;
    testFinished = cached != null && cached.isNotEmpty;
    routineHistory.clear();
    notifyListeners();

    try {
      final ResponseModel resp = await TestController.hasRoutine();
      if (resp.data['routine'] != null) {
        final String routineResp = resp.data['routine'];
        testFinished = true;
        routine = routineResp;
        await UserPreferences.setRoutine(routineResp);
        cachedRoutineDate = UserPreferences.routineDate;
      } else if (routine == null) {
        // Si no hay rutina en el servidor ni local, cargamos las preguntas del test
        await getAllTest();
      }
    } catch (_) {
      // Sin conexión a internet
      isOffline = true;
      if (routine != null) {
        testFinished = true;
      }
    }

    isLoading = false;
    notifyListeners();

    // Cargar historial en segundo plano
    fetchHistory();
  }

  Future<void> refreshRoutine() async {
    await init();
  }

  Future<void> fetchHistory() async {
    if (UserPreferences.id == null) return;
    try {
      isLoadingHistory = true;
      notifyListeners();
      final list = await TestController.getRoutineHistory();
      routineHistory = list.map((item) => RoutineHistoryModel.fromJson(Map<String, dynamic>.from(item))).toList();
    } catch (_) {
      // Error silencioso de red en segundo plano
    } finally {
      isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<void> startRetake() async {
    isRetaking = true;
    answers.clear();
    selectedAnswer = null;
    notifyListeners();

    if (test == null) {
      isLoading = true;
      notifyListeners();
      await getAllTest();
      isLoading = false;
      notifyListeners();
    }

    Get.to(() => const TestView());
  }

  void viewRoutineFromHistory(RoutineHistoryModel item) {
    routine = item.routine;
    cachedRoutineDate = item.createdAt?.toIso8601String();
    notifyListeners();
  }

  void reset() {
    routine = null;
    cachedRoutineDate = null;
    testFinished = false;
    answers.clear();
    selectedAnswer = null;
    routineHistory.clear();
    isOffline = false;
    isRetaking = false;
    isLoading = false;
    notifyListeners();
  }

  Future<void> getAllTest() async {
    test = await TestController.getAllTest();
  }

  Future<void> reloadTest() async {
    isLoading = true;
    notifyListeners();
    await getAllTest();
    isLoading = false;
    notifyListeners();
  }

  void setSelectedAnswer(AnswersOption answer) {
    selectedAnswer = answer;
    notifyListeners();
  }

  void previousQuestion() {
    if (answers.isNotEmpty) {
      answers.removeLast();
      selectedAnswer = null;
      notifyListeners();
    }
  }

  void addAnswer(int questionId, int answerId) async {
    answers.add({questionId, answerId});
    selectedAnswer = null;

    if (answers.length == test!.questions.length) {
      notifyListeners();
      await sendAnswers();
      return;
    }

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
      testFinished = true;
      isRetaking = false;
      routine = resp.data['routine'];
      if (routine != null) {
        await UserPreferences.setRoutine(routine!);
        cachedRoutineDate = UserPreferences.routineDate;
      }
      fetchHistory();
      notifyListeners();
      toGoHome();
    } else {
      // Si hubo un error al enviar o generar con IA, retrocedemos la última respuesta para permitir reintentar sin RangeError
      if (answers.isNotEmpty) {
        answers.removeLast();
      }
      notifyListeners();
    }
  }

  void toGoHome() {
    isRetaking = false;
    Get.to(() => const HomeView());
  }
}
