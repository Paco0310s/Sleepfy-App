import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/models/question_model.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  // Este test de evaluación del sueño con preguntas de opción múltiple te permitirá identificar
  // posibles causas de insomnio y analizar tus hábitos de sueño. Las preguntas están diseñadas
  // para dar una idea rápida de los factores que podrían estar afectando tu descanso.
  @override
  Widget build(BuildContext context) {
    final TestProvider testProvider = Provider.of<TestProvider>(context);

    if (testProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Constants.kPrimaryColor),
        ),
      );
    }

    if (testProvider.test == null) {
      return const Scaffold(
        body: Center(
          child: MyText('No se ha cargado el test, reinicie la aplicación'),
        ),
      );
    }

    final bool testFinished = testProvider.testFinished;

    if (testFinished) {
      return Scaffold(
        appBar: AppBar(
          title: const MyTitleAppBar(title: 'Cuestionario'),
        ),
        body: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gap(80),
                  MyText(
                    '¡Felicidades!',
                    color: Constants.kBackgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  Gap(10),
                  MyText(
                    'Has completado el cuestionario',
                    color: Constants.kBackgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  Gap(40),
                  MyText(
                    'Presiona el botón para volver al inicio',
                    color: Constants.kBackgroundColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                  Gap(40),
                  Icon(Icons.check_circle, size: 100, color: Constants.kPrimaryColor)
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: MyButton(
                text: 'Volver al inicio',
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home),
                    SizedBox(width: 10),
                    MyText('Volver al inicio'),
                  ],
                ),
                onPressed: () => testProvider.toGoHome(),
              ),
            ),
          ],
        ),
      );
    }

    final int totalQuestions = testProvider.test!.questions.length;
    final int index = testProvider.answers.length;
    final Question currentQuestion = testProvider.test!.questions[index];
    final int currentQuestionIndex = index + 1;
    final double percentage = (currentQuestionIndex / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Cuestionario'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              LinearProgressBar(
                maxSteps: 100,
                minHeight: 5,
                progressType: LinearProgressBar.progressTypeLinear, // Use Linear progress
                currentStep: percentage.toInt(),
                progressColor: Constants.kPrimaryColor,
                backgroundColor: Constants.kPrimaryColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(0), //  NEW
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      'Pregunta $currentQuestionIndex de $totalQuestions',
                      color: Constants.kBackgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                    const Gap(20),
                    MyText(
                      currentQuestion.question,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Constants.kBackgroundColor,
                    ),
                    const Gap(40),
                    ...testProvider.test!.questions[index].answersOptions.map(
                      (answer) => Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: testProvider.selectedAnswer == answer ? Constants.kPrimaryColor.withValues(alpha: 0.9) : Colors.white,
                          border: Border.all(color: Constants.kBackgroundColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () => testProvider.setSelectedAnswer(answer),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  answer.answer,
                                  color: testProvider.selectedAnswer == answer ? Colors.white : Constants.kBackgroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                Icon(
                                  testProvider.selectedAnswer == answer ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: testProvider.selectedAnswer == answer ? Colors.white : Constants.kBackgroundColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: MyButton(
              text: 'Siguiente',
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward),
                  SizedBox(width: 10),
                  MyText('Siguiente'),
                ],
              ),
              onPressed: () {
                if (testProvider.selectedAnswer == null) {
                  return MySnackBar.showSnackBarError('Seleccione una respuesta');
                }

                testProvider.addAnswer(currentQuestion.id, testProvider.selectedAnswer!.id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
