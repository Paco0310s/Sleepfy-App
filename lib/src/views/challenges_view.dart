import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/controllers/content_controller.dart';
import 'package:sleepfy/models/content_item_model.dart';
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
  List<ContentItemModel> _challenges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _completedList = UserPreferences.completedChallenges;
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    final list = await ContentController.getActiveBySection(ContentSections.challenge);
    if (!mounted) return;
    setState(() {
      _challenges = list;
      _isLoading = false;
    });
  }

  String _challengeKey(ContentItemModel item) {
    return item.id > 0 ? item.id.toString() : item.title;
  }

  void _toggleChallenge(String key) async {
    HapticFeedback.lightImpact();
    await UserPreferences.toggleChallenge(key);
    setState(() {
      _completedList = UserPreferences.completedChallenges;
    });
  }

  String _rankForProgress(double progress) {
    if (progress >= 0.9) return '👑 Gran Maestro Zen';
    if (progress >= 0.6) return '⚡ Guerrero del Descanso';
    if (progress >= 0.3) return '🌙 Guardián Nocturno';
    return '🌱 Aprendiz del Sueño';
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount = _challenges
        .where((c) => _completedList.contains(_challengeKey(c)))
        .length;
    final double progress = _challenges.isEmpty
        ? 0.0
        : (completedCount / _challenges.length).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Desafíos de Sueño'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Constants.primary(context)))
          : RefreshIndicator(
              color: Constants.kSageGreen,
              onRefresh: _loadChallenges,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tarjeta de Progreso y Rango
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Constants.surface(context),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Constants.border(context), width: 1.2),
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
                                      color: Constants.surfaceLight(context),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFD49E3D), size: 20),
                                  ),
                                  const Gap(10),
                                  MyText(
                                    _rankForProgress(progress),
                                    color: Constants.textPrimary(context),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.5,
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Constants.kSageGreen.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: MyText(
                                  '$completedCount de ${_challenges.length}',
                                  color: Constants.kSageGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Gap(14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 7,
                              backgroundColor: Constants.surfaceLight(context),
                              valueColor: const AlwaysStoppedAnimation<Color>(Constants.kSageGreen),
                            ),
                          ),
                          const Gap(10),
                          MyText(
                            _challenges.isNotEmpty && completedCount == _challenges.length
                                ? '¡Felicidades! Has dominado todos los hábitos de descanso.'
                                : 'Toca cada tarjeta para marcar los hábitos que vayas cumpliendo.',
                            fontSize: 12,
                            color: Constants.textSecondary(context),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),

                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: MyText(
                        'Tus Desafíos Semanales',
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                    ),
                    const Gap(12),

                    // Lista de Desafíos interactivos
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _challenges.length,
                      itemBuilder: (context, index) {
                        final challenge = _challenges[index];
                        final String key = _challengeKey(challenge);
                        final bool isCompleted = _completedList.contains(key);

                        return GestureDetector(
                          onTap: () => _toggleChallenge(key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? Constants.kSageGreen.withValues(alpha: 0.1)
                                  : Constants.surface(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isCompleted ? Constants.kSageGreen.withValues(alpha: 0.6) : Constants.border(context),
                                width: isCompleted ? 1.4 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isCompleted ? Constants.kSageGreen : Colors.transparent,
                                        border: Border.all(
                                          color: isCompleted ? Constants.kSageGreen : Constants.border(context),
                                          width: 1.8,
                                        ),
                                      ),
                                      child: isCompleted
                                          ? const Icon(Icons.check, size: 15, color: Colors.white)
                                          : null,
                                    ),
                                    const Gap(12),
                                    Expanded(
                                      child: MyText(
                                        challenge.title,
                                        color: isCompleted ? Constants.kSageGreen : Constants.textPrimary(context),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.5,
                                      ),
                                    ),
                                  ],
                                ),
                                if ((challenge.subtitle ?? '').isNotEmpty) ...[
                                  const Gap(10),
                                  _buildInfoRow(context, 'Objetivo:', challenge.subtitle!, Constants.accent(context)),
                                ],
                                if ((challenge.body ?? '').isNotEmpty) ...[
                                  const Gap(6),
                                  _buildInfoRow(context, 'Cómo lograrlo:', challenge.body!, Constants.textPrimary(context)),
                                ],
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
            ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String content, Color labelColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          label,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: labelColor,
        ),
        const Gap(2),
        MyText(
          content,
          fontSize: 12.5,
          color: Constants.textSecondary(context),
        ),
      ],
    );
  }
}
