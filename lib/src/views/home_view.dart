import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/ai_chat_view.dart';
import 'package:sleepfy/src/views/breathing_exercise_view.dart';
import 'package:sleepfy/src/views/challenges_view.dart';
import 'package:sleepfy/src/views/chart_view.dart';
import 'package:sleepfy/src/views/control_dreams_view.dart';
import 'package:sleepfy/src/views/results_view.dart';
import 'package:sleepfy/src/views/settings_view.dart';
import 'package:sleepfy/src/views/sleep_calculator_view.dart';
import 'package:sleepfy/src/views/test_view.dart';
import 'package:sleepfy/src/views/tools_view.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  String _getDynamicGreeting() {
    final hour = DateTime.now().hour;
    final rawName = UserPreferences.name?.trim();
    final firstName = (rawName != null && rawName.isNotEmpty) ? ', ${rawName.split(' ').first}' : '';

    if (hour >= 5 && hour < 12) {
      return '☀️ Buenos días$firstName · Que tengas un día lleno de energía';
    } else if (hour >= 12 && hour < 19) {
      return '🌤️ Buenas tardes$firstName · Cuida tus hábitos para esta noche';
    } else {
      return '🌙 Buenas noches$firstName · Es momento de preparar tu descanso';
    }
  }

  @override
  Widget build(BuildContext context) {
    final TestProvider testProvider = Provider.of<TestProvider>(context);

    return Scaffold(
      backgroundColor: Constants.background(context),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Constants.primary(context),
        elevation: 2,
        onPressed: () => Get.to(() => const AiChatView()),
        icon: Icon(Icons.auto_awesome, color: Constants.primaryContent(context), size: 18),
        label: MyText(
          'Sleepfy AI',
          color: Constants.primaryContent(context),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: Constants.accent(context),
              backgroundColor: Constants.surface(context),
              onRefresh: () => testProvider.refreshRoutine(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Header elegante y minimalista fiel a los colores del logo
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 26, bottom: 20),
                      decoration: BoxDecoration(
                        color: Constants.background(context),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Constants.border(context),
                                width: 1.5,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/icon.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Gap(14),
                          MyText(
                            'Sleepfy',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: Constants.textPrimary(context),
                          ),
                          const Gap(4),
                          MyText(
                            'Tu guía hacia el descanso profundo',
                            fontSize: 13.5,
                            color: Constants.textSecondary(context),
                          ),
                          const Gap(12),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Constants.surface(context),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Constants.border(context),
                              ),
                            ),
                            child: MyText(
                              _getDynamicGreeting(),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Constants.textPrimary(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tarjeta de estado: Cuestionario o Resultados
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Builder(builder: (context) {
                        if (testProvider.isLoading) {
                          return Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Constants.surface(context),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Constants.border(context)),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(color: Constants.accent(context)),
                            ),
                          );
                        }

                        if (testProvider.testFinished) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Constants.surface(context),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Constants.border(context), width: 1.2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Constants.kSageGreen.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.check_circle_outline_rounded,
                                        color: Constants.kSageGreen,
                                        size: 22,
                                      ),
                                    ),
                                    const Gap(12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            'Cuestionario completado',
                                            color: Constants.textPrimary(context),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          const Gap(2),
                                          MyText(
                                            'Tu rutina de descanso está lista',
                                            color: Constants.textSecondary(context),
                                            fontSize: 12.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(16),
                                MyButton(
                                  text: 'Ver mi rutina personalizada',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.auto_awesome, size: 18, color: Constants.primaryContent(context)),
                                      const Gap(8),
                                      MyText(
                                        'Ver mi rutina personalizada',
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.primaryContent(context),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    Get.to(() => const ResultsView());
                                  },
                                ),
                                const Gap(6),
                                Center(
                                  child: TextButton.icon(
                                    icon: Icon(Icons.refresh_rounded, size: 15, color: Constants.textSecondary(context)),
                                    label: MyText(
                                      'Reevaluar mis hábitos de sueño',
                                      color: Constants.textSecondary(context),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    onPressed: () => testProvider.startRetake(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Constants.surface(context),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Constants.border(context), width: 1.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Constants.surfaceLight(context),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.bedtime_outlined,
                                      color: Constants.accent(context),
                                      size: 22,
                                    ),
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          'Análisis de descanso',
                                          color: Constants.textPrimary(context),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        const Gap(2),
                                        MyText(
                                          'Descubre por qué te cuesta dormir',
                                          color: Constants.textSecondary(context),
                                          fontSize: 12.5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(12),
                              MyText(
                                'Responde un cuestionario clínico rápido para que Sleepfy diseñe una rutina personalizada según tus hábitos.',
                                color: Constants.textSecondary(context),
                                fontSize: 13,
                                height: 1.45,
                              ),
                              const Gap(16),
                              MyButton(
                                text: 'Comenzar cuestionario',
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.play_arrow_rounded, size: 20, color: Constants.primaryContent(context)),
                                    const Gap(6),
                                    MyText(
                                      'Comenzar cuestionario',
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: Constants.primaryContent(context),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Get.to(() => const TestView());
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  // Barra de herramientas interactivas populares
                  const SliverToBoxAdapter(
                    child: _QuickToolsBar(),
                  ),

                  // Check-in matutino de energía
                  const SliverToBoxAdapter(
                    child: _MorningCheckInCard(),
                  ),

                  // Gráfica de horas de sueño
                  const SliverToBoxAdapter(
                    child: ChartView(),
                  ),

                  // Resumen compacto de descanso
                  const SliverToBoxAdapter(
                    child: _SleepSummaryCard(),
                  ),

                  // Banner de adquisición del Kit Sleepfy
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Constants.surface(context),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Constants.border(context), width: 1),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Constants.surfaceLight(context),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.spa_outlined,
                                    color: Constants.kSageGreen,
                                    size: 24,
                                  ),
                                ),
                                const Gap(14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        'Kit Sleepfy de Relajación',
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.textPrimary(context),
                                      ),
                                      const Gap(2),
                                      MyText(
                                        'Aromaterapia, bálsamos e infusiones relajantes',
                                        fontSize: 12,
                                        color: Constants.textSecondary(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Gap(14),
                            MyButton(
                              outlined: true,
                              text: 'Conocer y adquirir el kit',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_bag_outlined, color: Constants.textPrimary(context), size: 18),
                                  const Gap(8),
                                  MyText(
                                    'Conocer y adquirir el kit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Constants.textPrimary(context),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                const urlInstagram = 'https://www.instagram.com/_sleepfy/';
                                const String phone1 = '3921694141';
                                const String phone2 = '3929308377';

                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Constants.surface(context),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        side: BorderSide(color: Constants.border(context)),
                                      ),
                                      title: const MyTitleAppBar(title: 'Adquiere tu kit Sleepfy'),
                                      content: Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: const [
                                          SocialNetworkItem(
                                            image: 'assets/images/instagram.png',
                                            url: urlInstagram,
                                            text: 'Instagram',
                                          ),
                                          SocialNetworkItem(
                                            image: 'assets/images/whatsapp.png',
                                            url: 'https://wa.me/52$phone1',
                                            text: 'WhatsApp 1',
                                          ),
                                          SocialNetworkItem(
                                            image: 'assets/images/whatsapp.png',
                                            url: 'https://wa.me/52$phone2',
                                            text: 'WhatsApp 2',
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: Gap(20)),
                ],
              ),
            ),

            // Botones flotantes modernos (Settings & Tools)
            Positioned(
              left: 16,
              top: 14,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HeaderFloatingButton(
                    icon: Icons.tune_rounded,
                    onPressed: () {
                      Get.to(() => const SettingsView(), transition: Transition.leftToRight);
                    },
                  ),
                  _HeaderFloatingButton(
                    icon: Icons.grid_view_rounded,
                    onPressed: () {
                      Get.to(() => const ToolsView(), transition: Transition.rightToLeft);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderFloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderFloatingButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.surface(context),
        shape: BoxShape.circle,
        border: Border.all(color: Constants.border(context), width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, color: Constants.textPrimary(context), size: 20),
        onPressed: onPressed,
      ),
    );
  }
}

class SocialNetworkItem extends StatelessWidget {
  final String image;
  final String url;
  final String text;

  const SocialNetworkItem({super.key, required this.image, required this.url, required this.text});

  @override
  Widget build(BuildContext context) {
    return MyButton(
      color: Constants.surfaceLight(context),
      text: text,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 22),
          const Gap(10),
          MyText(
            text,
            color: Constants.textPrimary(context),
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
      onPressed: () {
        _launchURL(url);
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

class _SleepSummaryCard extends StatelessWidget {
  const _SleepSummaryCard();

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ControlDreamsProvider>(context);
    final schedules = prov.sleepSchedules;

    // Calcular promedio de la semana
    double totalHours = 0;
    int count = 0;
    for (final s in schedules) {
      final hours = s.end.difference(s.start).inMinutes / 60.0;
      if (hours > 0 && hours <= 24) {
        totalHours += hours;
        count++;
      }
    }
    final double avgHours = count > 0 ? (totalHours / count) : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Constants.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Constants.border(context)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Constants.surfaceLight(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.bedtime_outlined,
                color: Constants.accent(context),
                size: 20,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    count > 0 ? 'Promedio: ${avgHours.toStringAsFixed(1)} hrs / noche' : 'Registra tus horas de sueño',
                    color: Constants.textPrimary(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  const Gap(2),
                  MyText(
                    count > 0 ? '$count de 7 días registrados' : 'Toca para registrar tu descanso diario',
                    color: Constants.textSecondary(context),
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline_rounded, color: Constants.accent(context), size: 22),
              tooltip: 'Registrar horas',
              onPressed: () => Get.to(() => const ControlDreamsView()),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickToolsBar extends StatelessWidget {
  const _QuickToolsBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: MyText(
              'Herramientas Rápidas',
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: Constants.textPrimary(context),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _QuickToolPill(
                  icon: Icons.auto_awesome,
                  title: 'Hablar con IA',
                  onTap: () => Get.to(() => const AiChatView()),
                ),
                const Gap(8),
                _QuickToolPill(
                  icon: Icons.calculate_outlined,
                  title: 'Calculadora 90m',
                  onTap: () => Get.to(() => const SleepCalculatorView()),
                ),
                const Gap(8),
                _QuickToolPill(
                  icon: Icons.air_rounded,
                  title: 'Respiración 4-7-8',
                  onTap: () => Get.to(() => const BreathingExerciseView()),
                ),
                const Gap(8),
                _QuickToolPill(
                  icon: Icons.emoji_events_outlined,
                  title: 'Desafíos',
                  onTap: () => Get.to(() => const ChallengesView()),
                ),
                const Gap(8),
                _QuickToolPill(
                  icon: Icons.grid_view_rounded,
                  title: 'Más herramientas',
                  onTap: () => Get.to(() => const ToolsView()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickToolPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickToolPill({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: Constants.surface(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Constants.border(context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Constants.accent(context), size: 17),
            const Gap(8),
            MyText(
              title,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Constants.textPrimary(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _MorningCheckInCard extends StatefulWidget {
  const _MorningCheckInCard();

  @override
  State<_MorningCheckInCard> createState() => _MorningCheckInCardState();
}

class _MorningCheckInCardState extends State<_MorningCheckInCard> {
  final List<Map<String, String>> moods = const [
    {"key": "energy", "emoji": "⚡", "label": "Con energía"},
    {"key": "good", "emoji": "🙂", "label": "Descansado"},
    {"key": "tired", "emoji": "🥱", "label": "Pesado"},
    {"key": "exhausted", "emoji": "😵", "label": "Agotado"},
  ];

  void _selectMood(String key, String label) async {
    await UserPreferences.setMorningMood(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool hasCheckedIn = UserPreferences.hasCheckedInToday;
    final String? currentMoodKey = UserPreferences.morningMood;
    final Map<String, String>? currentMood = moods.cast<Map<String, String>?>().firstWhere(
          (m) => m?["key"] == currentMoodKey,
          orElse: () => null,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Constants.surface(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hasCheckedIn ? Constants.kSageGreen.withValues(alpha: 0.5) : Constants.border(context),
            width: 1.2,
          ),
        ),
        child: hasCheckedIn && currentMood != null
            ? Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Constants.kSageGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(currentMood["emoji"]!, style: const TextStyle(fontSize: 24)),
                  ),
                  const Gap(14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Constants.kSageGreen, size: 16),
                            const Gap(6),
                            MyText(
                              'Hoy despertaste: ${currentMood["label"]}',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Constants.textPrimary(context),
                            ),
                          ],
                        ),
                        const Gap(2),
                        MyText(
                          'Registro matutino guardado. ¡Que tengas un día excelente!',
                          fontSize: 12,
                          color: Constants.textSecondary(context),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await UserPreferences.setMorningMood('');
                      setState(() {});
                    },
                    child: MyText(
                      'Cambiar',
                      fontSize: 12,
                      color: Constants.accent(context),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny_rounded, color: Color(0xFFE5A93C), size: 20),
                      const Gap(8),
                      MyText(
                        'Check-in Matutino: ¿Cómo despertaste hoy?',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                    ],
                  ),
                  const Gap(4),
                  MyText(
                    'Toca una opción para correlacionar tu descanso con tu energía diaria:',
                    fontSize: 12,
                    color: Constants.textSecondary(context),
                  ),
                  const Gap(14),
                  Row(
                    children: moods.map((m) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _selectMood(m["key"]!, m["label"]!),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Constants.surfaceLight(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Constants.border(context)),
                            ),
                            child: Column(
                              children: [
                                Text(m["emoji"]!, style: const TextStyle(fontSize: 22)),
                                const Gap(4),
                                MyText(
                                  m["label"]!,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Constants.textPrimary(context),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
      ),
    );
  }
}
