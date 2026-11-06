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
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Herramientas de Descanso'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _ToolCardItem(
            icon: Icons.auto_awesome,
            iconColor: Constants.accent(context),
            title: 'Sleepfy AI Coach (Chat en Vivo)',
            subtitle: 'Habla con nuestra IA sobre tu rutina o si no puedes dormir hoy',
            onTap: () => Get.to(() => const AiChatView()),
          ),
          const Gap(10),
          _ToolCardItem(
            icon: Icons.calculate_outlined,
            iconColor: Constants.accent(context),
            title: 'Calculadora de Ciclos (90 min)',
            subtitle: 'Calcula a qué hora acostarte para despertar sin fatiga',
            onTap: () => Get.to(() => const SleepCalculatorView()),
          ),
          const Gap(10),
          _ToolCardItem(
            icon: Icons.air_rounded,
            iconColor: Constants.kSageGreen,
            title: 'Respiración Guiada 4-7-8',
            subtitle: 'Orbe visual interactivo para inducir el descanso',
            onTap: () => Get.to(() => const BreathingExerciseView()),
          ),
          const Gap(10),
          _ToolCardItem(
            icon: Icons.self_improvement_rounded,
            iconColor: Constants.kSageGreen,
            title: 'Meditación y Relajación',
            subtitle: 'Ejercicios guiados para calmar la mente',
            onTap: () => Get.to(() => MeditationsView()),
          ),
          const Gap(10),
          _ToolCardItem(
            icon: Icons.music_note_rounded,
            iconColor: Constants.accent(context),
            title: 'Música y Sonidos Relajantes',
            subtitle: 'Ruido blanco, melodías y frecuencias delta',
            onTap: () => Get.to(() => const MusicView()),
          ),
          const Gap(10),
          _ToolCardItem(
            icon: Icons.headphones_rounded,
            iconColor: Constants.accent(context),
            title: 'Podcasts de Relajación',
            subtitle: 'Historias de sueño y reflexiones nocturnas',
            onTap: () => Get.to(() => PodcastsView()),
          ),
          const Gap(10),
          _ToolCardItem(
            icon: Icons.emoji_events_outlined,
            iconColor: const Color(0xFFD49E3D),
            title: 'Desafíos y Logros de Sueño',
            subtitle: 'Metas semanales para consolidar tu rutina',
            onTap: () => Get.to(() => const ChallengesView()),
          ),
          const Gap(10),
          _ToolCardItem(
            icon: Icons.bedtime_outlined,
            iconColor: Constants.kSageGreen,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Constants.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Constants.border(context), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 21),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    title,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Constants.textPrimary(context),
                  ),
                  const Gap(2),
                  MyText(
                    subtitle,
                    fontSize: 12,
                    color: Constants.textSecondary(context),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Constants.textSecondary(context).withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
