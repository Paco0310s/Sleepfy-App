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
    final firstName = (rawName != null && rawName.isNotEmpty)
        ? ', ${rawName.split(' ').first}'
        : '';

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
      backgroundColor: Constants.kBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Constants.kPrimaryColor,
        elevation: 6,
        onPressed: () => Get.to(() => const AiChatView()),
        icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
        label: const MyText(
          'AI Coach',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13.5,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: Constants.kPrimaryColor,
              backgroundColor: Constants.kSurfaceColor,
              onRefresh: () => testProvider.refreshRoutine(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Header elegante con logo y saludo inteligente
                  SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 30, bottom: 20),
                    decoration: const BoxDecoration(
                      gradient: Constants.kHeaderGradient,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Constants.kPrimaryColor.withValues(alpha: 0.25),
                                blurRadius: 25,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Gap(14),
                        const MyText(
                          'Sleepfy',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Constants.kTextColor,
                        ),
                        const Gap(4),
                        const MyText(
                          'Tu guía hacia el descanso profundo',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Constants.kTextSecondaryColor,
                        ),
                        const Gap(12),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Constants.kSurfaceColor.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Constants.kSecondaryColor.withValues(alpha: 0.35),
                            ),
                          ),
                          child: MyText(
                            _getDynamicGreeting(),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Constants.kTextColor,
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
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Constants.kSurfaceColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Constants.kBorderColor),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(color: Constants.kPrimaryColor),
                          ),
                        );
                      }

                      if (testProvider.testFinished) {
                        return Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1E293B), Color(0xFF1E1B4B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Constants.kPrimaryColor.withValues(alpha: 0.4), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Constants.kPrimaryColor.withValues(alpha: 0.15),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Constants.kMintColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: Constants.kMintColor,
                                      size: 24,
                                    ),
                                  ),
                                  const Gap(12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          '¡Cuestionario Completado!',
                                          color: Constants.kTextColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                        Gap(2),
                                        MyText(
                                          'Tu rutina de sueño está lista',
                                          color: Constants.kTextSecondaryColor,
                                          fontSize: 13,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(18),
                              MyButton(
                                text: 'Ver mi rutina personalizada',
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.auto_awesome, size: 20, color: Colors.white),
                                    Gap(10),
                                    MyText(
                                      'Ver mi rutina personalizada',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Get.to(() => const ResultsView());
                                },
                              ),
                              const Gap(8),
                              Center(
                                child: TextButton.icon(
                                  icon: const Icon(Icons.refresh_rounded, size: 16, color: Constants.kSecondaryColor),
                                  label: const MyText(
                                    'Reevaluar mis hábitos de sueño',
                                    color: Constants.kSecondaryColor,
                                    fontSize: 13,
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
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E293B), Color(0xFF26334D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Constants.kBorderColor, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Constants.kPrimaryColor.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.bedtime_outlined,
                                    color: Constants.kSecondaryColor,
                                    size: 24,
                                  ),
                                ),
                                const Gap(12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        'Análisis de Sueño',
                                        color: Constants.kTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                      Gap(2),
                                      MyText(
                                        'Descubre por qué te cuesta dormir',
                                        color: Constants.kTextSecondaryColor,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Gap(14),
                            const MyText(
                              'Responde un cuestionario rápido para generar una rutina de descanso diseñada para ti con IA.',
                              color: Constants.kTextSecondaryColor,
                              fontSize: 13.5,
                            ),
                            const Gap(18),
                            MyButton(
                              text: 'Comenzar cuestionario',
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_arrow_rounded, size: 22, color: Colors.white),
                                  Gap(8),
                                  MyText(
                                    'Comenzar cuestionario',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E293B), Color(0xFF172554)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Constants.kSecondaryColor.withValues(alpha: 0.3), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Constants.kSecondaryColor.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.spa_rounded,
                                  color: Constants.kSecondaryColor,
                                  size: 26,
                                ),
                              ),
                              const Gap(14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      'Kit Sleepfy de Relajación',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.kTextColor,
                                    ),
                                    Gap(4),
                                    MyText(
                                      'Aromaterapia, bálsamos e infusiones relajantes',
                                      fontSize: 12.5,
                                      color: Constants.kTextSecondaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(16),
                          MyButton(
                            color: Constants.kSecondaryColor.withValues(alpha: 0.9),
                            text: 'Adquiere tu kit aquí',
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined, color: Constants.kBackgroundColor, size: 20),
                                Gap(8),
                                MyText(
                                  'Conocer y adquirir el kit',
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.kBackgroundColor,
                                ),
                              ],
                            ),
                            onPressed: () {
                              const urlInstagram = 'https://www.instagram.com/_sleepfy/';
                              const String phone1 = '3921694141';
                              const String phone2 = '3921219786';

                              showAdaptiveDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Constants.kSurfaceColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(color: Constants.kBorderColor),
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
        color: Constants.kSurfaceColor.withValues(alpha: 0.8),
        shape: BoxShape.circle,
        border: Border.all(color: Constants.kBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Constants.kTextColor, size: 21),
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
      color: Constants.kSurfaceLightColor,
      text: text,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 22),
          const Gap(10),
          MyText(
            text,
            color: Constants.kTextColor,
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
          color: Constants.kSurfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Constants.kBorderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Constants.kSecondaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.bedtime_rounded,
                color: Constants.kSecondaryColor,
                size: 22,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    count > 0 ? 'Promedio: ${avgHours.toStringAsFixed(1)} hrs / noche' : 'Registra tus horas de sueño',
                    color: Constants.kTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                  ),
                  const Gap(2),
                  MyText(
                    count > 0 ? '$count de 7 días registrados esta semana' : 'Toca el botón para registrar tu descanso diario',
                    color: Constants.kTextSecondaryColor,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: Constants.kSecondaryColor, size: 24),
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
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: MyText(
              'Herramientas Rápidas',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Constants.kTextColor,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _QuickToolPill(
                  icon: Icons.auto_awesome,
                  color: const Color(0xFFA78BFA),
                  title: 'Hablar con IA',
                  onTap: () => Get.to(() => const AiChatView()),
                ),
                const Gap(10),
                _QuickToolPill(
                  icon: Icons.calculate_outlined,
                  color: Constants.kSecondaryColor,
                  title: 'Calculadora 90m',
                  onTap: () => Get.to(() => const SleepCalculatorView()),
                ),
                const Gap(10),
                _QuickToolPill(
                  icon: Icons.air_rounded,
                  color: Constants.kMintColor,
                  title: 'Respiración 4-7-8',
                  onTap: () => Get.to(() => const BreathingExerciseView()),
                ),
                const Gap(10),
                _QuickToolPill(
                  icon: Icons.emoji_events_outlined,
                  color: Constants.kWarningColor,
                  title: 'Desafíos de Sueño',
                  onTap: () => Get.to(() => const ChallengesView()),
                ),
                const Gap(10),
                _QuickToolPill(
                  icon: Icons.grid_view_rounded,
                  color: const Color(0xFF818CF8),
                  title: 'Todas las herramientas',
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
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _QuickToolPill({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Constants.kSurfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const Gap(10),
            MyText(
              title,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Constants.kTextColor,
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
          color: Constants.kSurfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hasCheckedIn ? Constants.kMintColor.withValues(alpha: 0.4) : Constants.kBorderColor,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: hasCheckedIn && currentMood != null
            ? Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Constants.kMintColor.withValues(alpha: 0.15),
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
                            const Icon(Icons.check_circle_rounded, color: Constants.kMintColor, size: 16),
                            const Gap(6),
                            MyText(
                              'Hoy despertaste: ${currentMood["label"]}',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Constants.kTextColor,
                            ),
                          ],
                        ),
                        const Gap(2),
                        const MyText(
                          'Registro matutino guardado. ¡Que tengas un día excelente!',
                          fontSize: 12,
                          color: Constants.kTextSecondaryColor,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await UserPreferences.setMorningMood('');
                      setState(() {});
                    },
                    child: const MyText(
                      'Cambiar',
                      fontSize: 12,
                      color: Constants.kSecondaryColor,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.wb_sunny_rounded, color: Color(0xFFFBBF24), size: 20),
                      Gap(8),
                      MyText(
                        'Check-in Matutino: ¿Cómo despertaste hoy?',
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Constants.kTextColor,
                      ),
                    ],
                  ),
                  const Gap(4),
                  const MyText(
                    'Toca una opción para correlacionar tu descanso con tu energía diaria:',
                    fontSize: 12,
                    color: Constants.kTextSecondaryColor,
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
                              color: Constants.kSurfaceLightColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Constants.kBorderColor),
                            ),
                            child: Column(
                              children: [
                                Text(m["emoji"]!, style: const TextStyle(fontSize: 22)),
                                const Gap(4),
                                MyText(
                                  m["label"]!,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Constants.kTextColor,
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
