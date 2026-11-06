import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/views/ai_chat_view.dart';
import 'package:sleepfy/src/views/breathing_exercise_view.dart';
import 'package:sleepfy/src/views/challenges_view.dart';
import 'package:sleepfy/src/views/control_dreams_view.dart';
import 'package:sleepfy/src/views/meditations_view.dart';
import 'package:sleepfy/src/views/music_view.dart';
import 'package:sleepfy/src/views/podcasts_view.dart';
import 'package:sleepfy/src/views/sleep_calculator_view.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class ToolsView extends StatelessWidget {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Herramientas de Descanso'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _ToolCardItem(
            icon: Icons.auto_awesome,
            iconColor: const Color(0xFFA78BFA),
            title: 'Sleepfy AI Coach (Chat en Vivo)',
            subtitle: 'Habla con nuestra IA sobre tu rutina o si no puedes dormir hoy',
            onTap: () => Get.to(() => const AiChatView()),
          ),
          const Gap(12),
          _ToolCardItem(
            icon: Icons.calculate_outlined,
            iconColor: Constants.kSecondaryColor,
            title: 'Calculadora de Ciclos (90 min)',
            subtitle: 'Calcula a qué hora acostarte para despertar sin fatiga',
            onTap: () => Get.to(() => const SleepCalculatorView()),
          ),
          const Gap(12),
          _ToolCardItem(
            icon: Icons.air_rounded,
            iconColor: Constants.kMintColor,
            title: 'Respiración Guiada 4-7-8',
            subtitle: 'Orbe visual interactivo para inducir el descanso',
            onTap: () => Get.to(() => const BreathingExerciseView()),
          ),
          const Gap(12),
          _ToolCardItem(
            icon: Icons.menu_book_rounded,
            iconColor: const Color(0xFF818CF8),
            title: 'Meditación y Relajación',
            subtitle: 'Ejercicios guiados para calmar la mente',
            onTap: () => Get.to(() => MeditationsView()),
          ),
          const Gap(12),
          _ToolCardItem(
            icon: Icons.music_note_rounded,
            iconColor: Constants.kPrimaryColor,
            title: 'Música y Sonidos Relajantes',
            subtitle: 'Ruido blanco, melodías y frecuencias delta',
            onTap: () => Get.to(() => const MusicView()),
          ),
          const Gap(12),
          _ToolCardItem(
            icon: Icons.headphones_rounded,
            iconColor: const Color(0xFF38BDF8),
            title: 'Podcasts de Relajación',
            subtitle: 'Historias de sueño y reflexiones nocturnas',
            onTap: () => Get.to(() => PodcastsView()),
          ),
          const Gap(12),
          _ToolCardItem(
            icon: Icons.emoji_events_outlined,
            iconColor: Constants.kWarningColor,
            title: 'Desafíos y Logros de Sueño',
            subtitle: 'Metas semanales para consolidar tu rutina',
            onTap: () => Get.to(() => const ChallengesView()),
          ),
          const Gap(12),
          _ToolCardItem(
            icon: Icons.bedtime_outlined,
            iconColor: const Color(0xFFF472B6),
            title: 'Control de Ciclos de Sueño',
            subtitle: 'Registra tus horarios de dormir y despertar',
            onTap: () => Get.to(() => const ControlDreamsView()),
          ),
        ],
      ),
    );
  }
}

class _ToolCardItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ToolCardItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Constants.kSurfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Constants.kBorderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    title,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: Constants.kTextColor,
                  ),
                  const Gap(3),
                  MyText(
                    subtitle,
                    fontSize: 12.5,
                    color: Constants.kTextSecondaryColor,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Constants.kTextSecondaryColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
