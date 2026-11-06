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

  @override
  Widget build(BuildContext context) {
    final TestProvider testProvider = Provider.of<TestProvider>(context);

    if (testProvider.isLoading) {
      return Scaffold(
        backgroundColor: Constants.background(context),
        body: Center(
          child: CircularProgressIndicator(color: Constants.accent(context)),
        ),
      );
    }

    if (testProvider.test == null) {
      return Scaffold(
        backgroundColor: Constants.background(context),
        appBar: AppBar(
          title: const MyTitleAppBar(title: 'Evaluación del Sueño'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off_rounded, size: 54, color: Constants.textSecondary(context)),
                const Gap(16),
                MyText(
                  'No se pudo cargar el cuestionario en este momento',
                  color: Constants.textPrimary(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                MyText(
                  'Verifica tu conexión a internet e inténtalo nuevamente.',
                  color: Constants.textSecondary(context),
                  fontSize: 13,
                  textAlign: TextAlign.center,
                ),
                const Gap(20),
                MyButton(
                  text: 'Reintentar carga',
                  onPressed: () => testProvider.reloadTest(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final bool testFinished = testProvider.testFinished;

    if (testFinished && !testProvider.isRetaking) {
      return Scaffold(
        backgroundColor: Constants.background(context),
        appBar: AppBar(
          title: const MyTitleAppBar(title: 'Cuestionario'),
        ),
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Constants.kSageGreen.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 64,
                        color: Constants.kSageGreen,
                      ),
                    ),
                    const Gap(22),
                    MyText(
                      '¡Cuestionario Completado!',
                      color: Constants.textPrimary(context),
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    MyText(
                      'Tus respuestas han sido procesadas para generar tu rutina personalizada.',
                      color: Constants.textSecondary(context),
                      fontSize: 13.5,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(24),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Constants.textPrimary(context),
                        side: BorderSide(color: Constants.border(context)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: Icon(Icons.refresh_rounded, size: 17, color: Constants.textPrimary(context)),
                      label: MyText(
                        'Actualizar mis respuestas',
                        color: Constants.textPrimary(context),
                        fontWeight: FontWeight.w500,
                        fontSize: 13.5,
                      ),
                      onPressed: () => testProvider.startRetake(),
                    ),
                    const Gap(100),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: MyButton(
                text: 'Volver al inicio',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_rounded, color: Constants.primaryContent(context), size: 19),
                    const Gap(8),
                    MyText(
                      'Volver al inicio',
                      color: Constants.primaryContent(context),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
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
    if (testProvider.answers.length >= totalQuestions) {
      return Scaffold(
        backgroundColor: Constants.background(context),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Constants.accent(context)),
                const Gap(20),
                MyText(
                  'Sleepfy AI está diseñando tu rutina personalizada...',
                  color: Constants.textPrimary(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                MyText(
                  'Analizando tus hábitos de sueño y respuestas clínicas',
                  color: Constants.textSecondary(context),
                  fontSize: 13,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    final int index = testProvider.answers.length;
    final Question currentQuestion = testProvider.test!.questions[index];
    final int currentQuestionIndex = index + 1;
    final double percentage = (currentQuestionIndex / totalQuestions) * 100;

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Evaluación del Sueño'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Barra de progreso estilizada
                LinearProgressBar(
                  maxSteps: 100,
                  minHeight: 5,
                  progressType: LinearProgressBar.progressTypeLinear,
                  currentStep: percentage.toInt(),
                  progressColor: Constants.accent(context),
                  backgroundColor: Constants.surfaceLight(context),
                  borderRadius: BorderRadius.circular(0),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge de número de pregunta y botón de retroceso
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Constants.surface(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Constants.border(context)),
                            ),
                            child: MyText(
                              'Pregunta $currentQuestionIndex de $totalQuestions',
                              color: Constants.textPrimary(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                          ),
                          if (index > 0)
                            TextButton.icon(
                              onPressed: () => testProvider.previousQuestion(),
                              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 13, color: Constants.textSecondary(context)),
                              label: MyText(
                                'Pregunta anterior',
                                fontSize: 12,
                                color: Constants.textSecondary(context),
                              ),
                            ),
                        ],
                      ),
                      const Gap(16),
                      MyText(
                        currentQuestion.question,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Constants.textPrimary(context),
                      ),
                      const Gap(24),

                      // Opciones de respuesta
                      ...testProvider.test!.questions[index].answersOptions.map(
                        (answer) {
                          final bool isSelected = testProvider.selectedAnswer == answer;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => testProvider.setSelectedAnswer(answer),
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Constants.surfaceLight(context)
                                      : Constants.surface(context),
                                  border: Border.all(
                                    color: isSelected ? Constants.accent(context) : Constants.border(context),
                                    width: isSelected ? 1.6 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        answer.answer,
                                        color: isSelected ? Constants.textPrimary(context) : Constants.textSecondary(context),
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        fontSize: 14.5,
                                      ),
                                    ),
                                    const Gap(12),
                                    Icon(
                                      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                      color: isSelected ? Constants.accent(context) : Constants.textSecondary(context),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: MyButton(
              text: 'Siguiente',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    'Siguiente',
                    color: Constants.primaryContent(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                  const Gap(8),
                  Icon(Icons.arrow_forward_rounded, color: Constants.primaryContent(context), size: 19),
                ],
              ),
              onPressed: () {
                if (testProvider.selectedAnswer == null) {
                  return MySnackBar.showSnackBarError('Selecciona una respuesta para continuar');
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
