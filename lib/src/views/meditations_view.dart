import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/views/breathing_exercise_view.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MeditationsView extends StatelessWidget {
  MeditationsView({super.key});

  final List<Map<String, String>> meditations = [
    {
      "title": "Respiración Profunda (4-4-6)",
      "instructions": "◆ Acuéstate en tu cama en una posición cómoda.\n\n"
          "◆ Cierra los ojos y toma una respiración profunda por la nariz, contando mentalmente hasta 4.\n\n"
          "◆ Mantén el aire suavemente durante 4 segundos.\n\n"
          "◆ Exhala lentamente por la boca contando hasta 6, soltando el aire como un suspiro cálido.\n\n"
          "◆ Repite este patrón durante 5 a 10 minutos, sintiendo cómo tu ritmo cardíaco y tu cuerpo se van desacelerando.",
    },
    {
      "title": "Relajación Muscular Progresiva",
      "instructions": "◆ Acuéstate cómodamente y cierra los ojos.\n\n"
          "◆ Concéntrate en tus pies: inhala y tensa los músculos de los dedos y plantas durante 5 segundos.\n\n"
          "◆ Exhala y suelta toda la tensión de golpe, notando el calor y alivio de la relajación.\n\n"
          "◆ Avanza lentamente: pantorrillas, muslos, glúteos, abdomen, hombros, cuello y rostro.\n\n"
          "◆ Dedica 10 a 15 minutos para escanear todo tu cuerpo.",
    },
    {
      "title": "Visualización Guiada",
      "instructions": "◆ Acuéstate cómodamente y respira de forma natural.\n\n"
          "◆ Imagina un paisaje nocturno en calma: una playa bajo la luna, un bosque sereno o una cabaña acogedora.\n\n"
          "◆ Siente la temperatura suave, el aroma fresco del aire y los sonidos lejanos de la naturaleza.\n\n"
          "◆ Deja que esa sensación de seguridad y paz te transporte suavemente hacia el sueño.",
    },
    {
      "title": "Afirmaciones Nocturnas",
      "instructions": "◆ Cierra los ojos y respira hondo por la nariz.\n\n"
          "◆ Repite mentalmente con cada exhalación:\n"
          "  • 'Suelto todo lo ocurrido en el día.'\n"
          "  • 'Mi cuerpo merece descansar y repararse.'\n"
          "  • 'Estoy en paz y a salvo en este momento.'\n\n"
          "◆ Permite que estas palabras disuelvan los pensamientos intrusivos.",
    },
    {
      "title": "Atención Plena (Mindfulness)",
      "instructions": "◆ Adopta una postura cómoda sin tensión en la espalda o cuello.\n\n"
          "◆ Centra tu atención únicamente en el flujo del aire al entrar por tu nariz y salir por tu boca.\n\n"
          "◆ Si aparece algún pensamiento, obsérvalo sin juzgarlo y déjalo pasar como una nube en el cielo, volviendo suavemente a tu respiración.",
    },
  ];

  final List<Map<String, String>> videos = [
    {"title": "Música Relajante con Sonidos de Lluvia", "url": "https://youtu.be/CkAOFDuxB38?si=ENjjRgHkelpzE4ld"},
    {"title": "Frecuencia 432 Hz para Conciliar el Sueño", "url": "https://youtu.be/x0Ig8XNc8d8?si=LTgPK9ONaCB0Dg2h"},
    {"title": "Meditación Guiada para Dormir Profundo", "url": "https://youtu.be/BTXcdQlXRJY?si=i5GsQ-GM47lm1NVe"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Meditación y Respiración'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Banner interactivo de Respiración 4-7-8
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF064E3B), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Constants.kMintColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Constants.kMintColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.air_rounded, color: Constants.kMintColor, size: 28),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyText(
                        'Respiración 4-7-8 Interactiva',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Constants.kTextColor,
                      ),
                      const Gap(2),
                      const MyText(
                        'Orbe visual animado con contador y pulsos para calmar el ritmo cardíaco.',
                        fontSize: 12,
                        color: Constants.kTextSecondaryColor,
                      ),
                      const Gap(10),
                      GestureDetector(
                        onTap: () => Get.to(() => const BreathingExerciseView()),
                        child: const Row(
                          children: [
                            MyText(
                              'Iniciar ejercicio ahora',
                              color: Constants.kMintColor,
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                            Gap(4),
                            Icon(Icons.arrow_forward_rounded, color: Constants.kMintColor, size: 16),
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

          const MyText(
            'Ejercicios de Respiración Guiada',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Constants.kTextColor,
          ),
          const Gap(10),

          // Lista de meditaciones
          ...meditations.map((meditation) => Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Constants.kSecondaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.air_rounded,
                      color: Constants.kSecondaryColor,
                      size: 22,
                    ),
                  ),
                  title: MyText(
                    meditation["title"]!,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Constants.kTextColor,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: Constants.kSecondaryColor),
                  onTap: () {
                    Get.to(() => MeditationDetailScreen(
                          title: meditation["title"]!,
                          instructions: meditation["instructions"]!,
                        ));
                  },
                ),
              )),

          const Gap(24),

          // Consejos adicionales
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF1E1B4B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Constants.kPrimaryColor.withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: Constants.kSecondaryColor, size: 22),
                    Gap(10),
                    MyText(
                      'Recomendaciones para tu Práctica',
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Constants.kTextColor,
                    ),
                  ],
                ),
                Gap(12),
                MyText(
                  '◆ Rutina: Practica a la misma hora para condicionar a tu cerebro al descanso.\n'
                  '◆ Ambiente: Reduce luces artificiales y mantén el cuarto fresco y ventilado.\n'
                  '◆ Desconexión: Deja tu celular fuera del alcance 30 minutos antes.',
                  fontSize: 13.5,
                  color: Constants.kTextSecondaryColor,
                ),
              ],
            ),
          ),

          const Gap(26),

          // Videos Section
          const MyText(
            'Sesiones y Videos de Relajación',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Constants.kTextColor,
          ),
          const Gap(10),

          ...videos.map((video) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Constants.kSurfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Constants.kBorderColor),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Constants.kPrimaryColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Constants.kSecondaryColor,
                      size: 24,
                    ),
                  ),
                  title: MyText(
                    video["title"]!,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                    color: Constants.kTextColor,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: Constants.kSecondaryColor),
                  onTap: () {
                    Get.to(() => MyVideoPlayer(url: video["url"]!, title: video["title"]!));
                  },
                ),
              )),
          const Gap(20),
        ],
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
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: MyTitleAppBar(title: title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Constants.kSurfaceColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Constants.kBorderColor),
          ),
          child: MyText(
            instructions,
            fontSize: 15,
            color: Constants.kTextColor,
          ),
        ),
      ),
    );
  }
}

class MyVideoPlayer extends StatefulWidget {
  final String title;
  final String url;

  const MyVideoPlayer({super.key, required this.url, required this.title});

  @override
  MyVideoPlayerState createState() => MyVideoPlayerState();
}

class MyVideoPlayerState extends State<MyVideoPlayer> {
  YoutubePlayerController? _controller;
  bool get _isMobileNative =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  void listener() {
    if (_controller?.value.playerState == PlayerState.ended) {
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_isMobileNative) {
      final String? videoId = YoutubePlayer.convertUrlToId(widget.url);
      if (videoId != null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            forceHD: false,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Reproductor de Relajación'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _isMobileNative && _controller != null
                  ? YoutubePlayer(
                      controller: _controller!,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Constants.kSecondaryColor,
                      progressColors: const ProgressBarColors(
                        playedColor: Constants.kSecondaryColor,
                        handleColor: Constants.kPrimaryColor,
                      ),
                      onReady: () {
                        _controller!.addListener(listener);
                      },
                    )
                  : InkWell(
                      onTap: () => _launchURL(widget.url),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Constants.kSurfaceLightColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Constants.kBorderColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Constants.kPrimaryColor.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                            ),
                            const Gap(12),
                            const MyText(
                              'Toca para abrir y reproducir el video',
                              color: Constants.kTextColor,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const Gap(18),
            MyText(
              widget.title,
              color: Constants.kTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const Gap(14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Constants.kSurfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Constants.kBorderColor),
              ),
              child: const MyText(
                'Acomódate en una posición relajada, cierra los ojos o mantén la mirada serena mientras la música y los sonidos reducen tu frecuencia mental hacia el estado de sueño.',
                color: Constants.kTextSecondaryColor,
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(24),
            MyButton(
              text: 'Abrir en YouTube',
              onPressed: () => _launchURL(widget.url),
              color: Constants.kSurfaceLightColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/youtube.png', width: 28, height: 28),
                  const Gap(10),
                  const MyText(
                    'Ver en YouTube',
                    color: Constants.kTextColor,
                    fontWeight: FontWeight.w600,
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

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    MySnackBar.showSnackBarError('No se pudo abrir la URL');
    throw 'No se pudo abrir la URL';
  }
}
