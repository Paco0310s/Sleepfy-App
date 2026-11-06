import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class ChallengesView extends StatefulWidget {
  const ChallengesView({super.key});

  @override
  State<ChallengesView> createState() => _ChallengesViewState();
}

class _ChallengesViewState extends State<ChallengesView> {
  late List<String> _completedList;

  final List<Map<String, String>> challenges = const [
    {
      "id": "1",
      "title": "Sin Pantallas Antes de Dormir",
      "goal": "Evitar el uso de dispositivos electrónicos 1 hora antes de dormir.",
      "solution": "Reemplaza el tiempo de pantalla por actividades relajantes como leer un libro o practicar respiración.",
    },
    {
      "id": "2",
      "title": "Hora Fija para Dormir",
      "goal": "Ir a la cama a la misma hora todos los días durante una semana.",
      "solution": "Programa un recordatorio 30 minutos antes y comienza tu ritual de relajación nocturno.",
    },
    {
      "id": "3",
      "title": "Diario de Sueño",
      "goal": "Llevar un diario de sueño y sensaciones durante 7 días.",
      "solution": "Cada mañana, registra cómo fue tu sueño y tu nivel de energía al despertar.",
    },
    {
      "id": "4",
      "title": "Ambiente de Sueño Ideal",
      "goal": "Mantener el dormitorio oscuro, fresco y silencioso durante 5 noches.",
      "solution": "Usa cortinas oscuras, regula la temperatura fresca y usa sonidos relajantes si hay ruido.",
    },
    {
      "id": "5",
      "title": "Desconexión Digital Nocturna",
      "goal": "Poner el teléfono en modo 'No molestar' o fuera de tu alcance en la cama.",
      "solution": "Coloca el cargador lejos de la mesita de noche para evitar la tentación de revisarlo.",
    },
    {
      "id": "6",
      "title": "Respiración 4-7-8 al Acostarte",
      "goal": "Practicar 4 ciclos de respiración profunda antes de cerrar los ojos.",
      "solution": "Usa la herramienta de Respiración 4-7-8 de Sleepfy para activar tu sistema parasimpático.",
    },
    {
      "id": "7",
      "title": "Cero Cafeína en la Tarde",
      "goal": "No consumir café, té o refrescos estimulantes después de las 2:00 PM.",
      "solution": "Sustituye la cafeína por infusiones relajantes de manzanilla o lavanda.",
    },
    {
      "id": "8",
      "title": "Noche de Sueño Completa",
      "goal": "Dormir al menos 7.5 horas continuas durante el fin de semana.",
      "solution": "Alinea tus ciclos de sueño calculándolos con la regla de los 90 minutos.",
    },
    {
      "id": "9",
      "title": "Cena Ligera y Temprana",
      "goal": "Cenar ligero al menos 2 horas antes de meterte en la cama.",
      "solution": "Evita comidas pesadas o grasas que obliguen a tu cuerpo a hacer digestión mientras intentas descansar.",
    },
    {
      "id": "10",
      "title": "Luz Solar al Despertar",
      "goal": "Exponerte a la luz natural durante 10 minutos al levantarte por la mañana.",
      "solution": "Abre las cortinas o sal al balcón. La luz solar ancla tu reloj biológico para la siguiente noche.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _completedList = UserPreferences.completedChallenges;
  }

  void _toggleChallenge(String id) async {
    HapticFeedback.lightImpact();
    await UserPreferences.toggleChallenge(id);
    setState(() {
      _completedList = UserPreferences.completedChallenges;
    });
  }

  String get _currentRank {
    final count = _completedList.length;
    if (count >= 9) return '👑 Gran Maestro Zen';
    if (count >= 6) return '⚡ Guerrero del Descanso';
    if (count >= 3) return '🌙 Guardián Nocturno';
    return '🌱 Aprendiz del Sueño';
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount = _completedList.length;
    final double progress = completedCount / challenges.length;

    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Desafíos de Sueño'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta Gamificada de Progreso y Rango
            Container(
              padding: const EdgeInsets.all(20),
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
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Constants.kSecondaryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.emoji_events_rounded, color: Constants.kSecondaryColor, size: 22),
                          ),
                          const Gap(10),
                          MyText(
                            _currentRank,
                            color: Constants.kTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Constants.kMintColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MyText(
                          '$completedCount de ${challenges.length}',
                          color: Constants.kMintColor,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                      backgroundColor: Constants.kSurfaceLightColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(Constants.kMintColor),
                    ),
                  ),
                  const Gap(10),
                  MyText(
                    completedCount == challenges.length
                        ? '¡Felicidades! Has dominado todos los hábitos de descanso.'
                        : 'Toca cada tarjeta para marcar los hábitos que vayas cumpliendo.',
                    fontSize: 12,
                    color: Constants.kTextSecondaryColor,
                  ),
                ],
              ),
            ),
            const Gap(22),

            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: MyText(
                'Tus Desafíos Semanales',
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: Constants.kTextColor,
              ),
            ),
            const Gap(12),

            // Lista de Desafíos interactivos
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                final String id = challenge["id"]!;
                final bool isCompleted = _completedList.contains(id);

                return GestureDetector(
                  onTap: () => _toggleChallenge(id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Constants.kMintColor.withValues(alpha: 0.08)
                          : Constants.kSurfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCompleted ? Constants.kMintColor.withValues(alpha: 0.7) : Constants.kBorderColor,
                        width: isCompleted ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted ? Constants.kMintColor : Colors.transparent,
                                border: Border.all(
                                  color: isCompleted ? Constants.kMintColor : Constants.kTextSecondaryColor,
                                  width: 2,
                                ),
                              ),
                              child: isCompleted
                                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                                  : null,
                            ),
                            const Gap(12),
                            Expanded(
                              child: MyText(
                                challenge["title"]!,
                                color: isCompleted ? Constants.kMintColor : Constants.kTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        _buildInfoRow('Objetivo:', challenge["goal"]!, Constants.kSecondaryColor),
                        const Gap(8),
                        _buildInfoRow('Cómo lograrlo:', challenge["solution"]!, Constants.kTextColor),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String content, Color labelColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          label,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: labelColor,
        ),
        const Gap(2),
        MyText(
          content,
          fontSize: 13,
          color: Constants.kTextSecondaryColor,
        ),
      ],
    );
  }
}
