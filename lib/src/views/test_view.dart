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
      return const Scaffold(
        backgroundColor: Constants.kBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: Constants.kPrimaryColor),
        ),
      );
    }

    if (testProvider.test == null) {
      return Scaffold(
        backgroundColor: Constants.kBackgroundColor,
        appBar: AppBar(
          title: const MyTitleAppBar(title: 'Evaluación del Sueño'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off_rounded, size: 54, color: Constants.kTextSecondaryColor),
                const Gap(16),
                const MyText(
                  'No se pudo cargar el cuestionario en este momento',
                  color: Constants.kTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                const MyText(
                  'Verifica tu conexión a internet e inténtalo nuevamente.',
                  color: Constants.kTextSecondaryColor,
                  fontSize: 13.5,
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
        backgroundColor: Constants.kBackgroundColor,
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
                        color: Constants.kMintColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 72,
                        color: Constants.kMintColor,
                      ),
                    ),
                    const Gap(24),
                    const MyText(
                      '¡Cuestionario Completado!',
                      color: Constants.kTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(10),
                    const MyText(
                      'Tus respuestas han sido procesadas para generar tu rutina personalizada.',
                      color: Constants.kTextSecondaryColor,
                      fontSize: 14.5,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(24),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Constants.kSecondaryColor,
                        side: const BorderSide(color: Constants.kSecondaryColor),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const MyText(
                        'Actualizar mis respuestas',
                        color: Constants.kSecondaryColor,
                        fontWeight: FontWeight.w600,
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_rounded, color: Colors.white),
                    Gap(10),
                    MyText(
                      'Volver al inicio',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
      return const Scaffold(
        backgroundColor: Constants.kBackgroundColor,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Constants.kSecondaryColor),
                Gap(20),
                MyText(
                  'Sleepfy AI está diseñando tu rutina personalizada...',
                  color: Constants.kTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
                Gap(8),
                MyText(
                  'Analizando tus hábitos de sueño y respuestas clínicas',
                  color: Constants.kTextSecondaryColor,
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
      backgroundColor: Constants.kBackgroundColor,
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
                  minHeight: 6,
                  progressType: LinearProgressBar.progressTypeLinear,
                  currentStep: percentage.toInt(),
                  progressColor: Constants.kSecondaryColor,
                  backgroundColor: Constants.kSurfaceLightColor,
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Constants.kSurfaceLightColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Constants.kBorderColor),
                            ),
                            child: MyText(
                              'Pregunta $currentQuestionIndex de $totalQuestions',
                              color: Constants.kSecondaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          if (index > 0)
                            TextButton.icon(
                              onPressed: () => testProvider.previousQuestion(),
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Constants.kTextSecondaryColor),
                              label: const MyText(
                                'Pregunta anterior',
                                fontSize: 12.5,
                                color: Constants.kTextSecondaryColor,
                              ),
                            ),
                        ],
                      ),
                      const Gap(16),
                      MyText(
                        currentQuestion.question,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Constants.kTextColor,
                      ),
                      const Gap(28),

                      // Opciones de respuesta
                      ...testProvider.test!.questions[index].answersOptions.map(
                        (answer) {
                          final bool isSelected = testProvider.selectedAnswer == answer;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: InkWell(
                              onTap: () => testProvider.setSelectedAnswer(answer),
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Constants.kPrimaryColor.withValues(alpha: 0.18)
                                      : Constants.kSurfaceColor,
                                  border: Border.all(
                                    color: isSelected ? Constants.kPrimaryColor : Constants.kBorderColor,
                                    width: isSelected ? 1.8 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Constants.kPrimaryColor.withValues(alpha: 0.2),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        answer.answer,
                                        color: isSelected ? Constants.kTextColor : Constants.kTextSecondaryColor,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Gap(12),
                                    Icon(
                                      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                      color: isSelected ? Constants.kSecondaryColor : Constants.kTextSecondaryColor,
                                      size: 22,
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    'Siguiente',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  Gap(8),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
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
