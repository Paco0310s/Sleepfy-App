import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/controllers/content_controller.dart';
import 'package:sleepfy/models/content_item_model.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/views/breathing_exercise_view.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MeditationsView extends StatefulWidget {
  const MeditationsView({super.key});

  @override
  State<MeditationsView> createState() => _MeditationsViewState();
}

class _MeditationsViewState extends State<MeditationsView> {
  List<ContentItemModel> _meditations = [];
  List<ContentItemModel> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final results = await Future.wait([
      ContentController.getActiveBySection(ContentSections.meditation),
      ContentController.getActiveBySection(ContentSections.meditationVideo),
    ]);
    if (!mounted) return;
    setState(() {
      _meditations = results[0];
      _videos = results[1];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Meditación y Respiración'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Constants.primary(context)))
          : RefreshIndicator(
              color: Constants.kSageGreen,
              onRefresh: _loadContent,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                children: [
                  // Banner interactivo de Respiración 4-7-8
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Constants.surface(context),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Constants.border(context)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Constants.surfaceLight(context),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.air_rounded, color: Constants.kSageGreen, size: 26),
                        ),
                        const Gap(14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                'Respiración 4-7-8 Interactiva',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Constants.textPrimary(context),
                              ),
                              const Gap(2),
                              MyText(
                                'Orbe visual animado con contador y pulsos para calmar el ritmo cardíaco.',
                                fontSize: 12,
                                color: Constants.textSecondary(context),
                              ),
                              const Gap(10),
                              GestureDetector(
                                onTap: () => Get.to(() => const BreathingExerciseView()),
                                child: const Row(
                                  children: [
                                    MyText(
                                      'Iniciar ejercicio ahora',
                                      color: Constants.kSageGreen,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    Gap(4),
                                    Icon(Icons.arrow_forward_rounded, color: Constants.kSageGreen, size: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),

                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: MyText(
                      'Ejercicios de Respiración Guiada',
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: Constants.textPrimary(context),
                    ),
                  ),
                  const Gap(10),

                  // Lista de meditaciones
                  ..._meditations.map((meditation) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Constants.surface(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Constants.border(context)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Constants.surfaceLight(context),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.air_rounded,
                              color: Constants.accent(context),
                              size: 20,
                            ),
                          ),
                          title: MyText(
                            meditation.title,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                            color: Constants.textPrimary(context),
                          ),
                          trailing: Icon(Icons.chevron_right_rounded, color: Constants.textSecondary(context), size: 20),
                          onTap: () {
                            Get.to(() => MeditationDetailScreen(
                                  title: meditation.title,
                                  instructions: meditation.body ?? meditation.subtitle ?? '',
                                ));
                          },
                        ),
                      )),

                  const Gap(20),

                  // Consejos adicionales
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Constants.surface(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Constants.border(context)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline_rounded, color: Constants.accent(context), size: 20),
                            const Gap(10),
                            MyText(
                              'Recomendaciones para tu Práctica',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Constants.textPrimary(context),
                            ),
                          ],
                        ),
                        const Gap(10),
                        MyText(
                          '◆ Rutina: Practica a la misma hora para condicionar a tu cerebro al descanso.\n'
                          '◆ Ambiente: Reduce luces artificiales y mantén el cuarto fresco y ventilado.\n'
                          '◆ Desconexión: Deja tu celular fuera del alcance 30 minutos antes.',
                          fontSize: 13,
                          color: Constants.textSecondary(context),
                          height: 1.5,
                        ),
                      ],
                    ),
                  ),

                  const Gap(22),

                  if (_videos.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: MyText(
                        'Sesiones y Videos de Relajación',
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                    ),
                    const Gap(10),

                    ..._videos.map((video) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Constants.surface(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Constants.border(context)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Constants.surfaceLight(context),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Constants.kSageGreen,
                                size: 22,
                              ),
                            ),
                            title: MyText(
                              video.title,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Constants.textPrimary(context),
                            ),
                            trailing: Icon(Icons.chevron_right_rounded, color: Constants.textSecondary(context), size: 20),
                            onTap: () {
                              final url = video.url ?? '';
                              if (url.isEmpty) {
                                MySnackBar.showSnackBarError('Enlace de video no disponible');
                                return;
                              }
                              Get.to(() => MyVideoPlayer(url: url, title: video.title));
                            },
                          ),
                        )),
                  ],
                  const Gap(20),
                ],
              ),
            ),
    );
  }
}

class MeditationDetailScreen extends StatelessWidget {
  final String title;
  final String instructions;

  const MeditationDetailScreen({super.key, required this.title, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: MyTitleAppBar(title: title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Constants.surface(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Constants.border(context)),
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
                    child: Icon(Icons.self_improvement_rounded, color: Constants.accent(context), size: 24),
                  ),
                  const Gap(14),
                  Expanded(
                    child: MyText(
                      title,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Constants.textPrimary(context),
                    ),
                  ),
                ],
              ),
              const Gap(18),
              Divider(color: Constants.border(context)),
              const Gap(14),
              MyText(
                instructions,
                fontSize: 14,
                color: Constants.textPrimary(context),
                height: 1.55,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyVideoPlayer extends StatefulWidget {
  final String url;
  final String title;

  const MyVideoPlayer({super.key, required this.url, required this.title});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      final videoId = YoutubePlayer.convertUrlToId(widget.url) ?? '';
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _launchExternal() async {
    final Uri uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      MySnackBar.showSnackBarError('No se pudo abrir el enlace');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: Constants.background(context),
        appBar: AppBar(
          title: MyTitleAppBar(title: widget.title),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.ondemand_video_rounded, size: 64, color: Constants.kSageGreen),
                const Gap(16),
                MyText(
                  widget.title,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Constants.textPrimary(context),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                MyButton(
                  text: 'Ver en YouTube',
                  onPressed: _launchExternal,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: MyTitleAppBar(title: widget.title),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Constants.kSageGreen,
          progressColors: const ProgressBarColors(
            playedColor: Constants.kSageGreen,
            handleColor: Constants.kSageGreen,
          ),
        ),
      ),
    );
  }
}
