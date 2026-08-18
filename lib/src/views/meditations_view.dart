import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MeditationsView extends StatelessWidget {
  MeditationsView({super.key});

  final List<Map<String, String>> meditations = [
    {
      "title": "Respiración Profunda",
      "instructions": "◆	Acuéstate en tu cama en una posición cómoda."
          "\n\n◆	Cierra los ojos y toma una respiración profunda por la nariz, contando hasta 4."
          "\n\n◆	Mantén el aire durante 4 segundos."
          "\n\n◆	Exhala lentamente por la boca, contando hasta 6."
          "\n\n◆	Repite este patrón de respiración durante 5-10 minutos, sintiendo cómo tu cuerpo se relaja más con cada exhalación."
    },
    {
      "title": "Relajación Progresiva",
      "instructions": "◆	Acuéstate cómodamente y cierra los ojos."
          "\n\n◆	Comienza concentrándote en tus pies. Inhala y tensa los músculos de los pies, manteniendo la tensión durante 5 segundos."
          "\n\n◆	Exhala y suelta la tensión, sintiendo cómo se relajan."
          "\n\n◆	Avanza lentamente por tu cuerpo: tobillos, pantorrillas, muslos, abdomen, pecho, brazos, cuello y cara, repitiendo el proceso en cada área."
          "\n\n◆	Tómate 10-15 minutos para completar el escaneo."
    },
    {
      "title": "Guiada de Imaginación",
      "instructions": "◆	Acuéstate cómodamente y cierra los ojos."
          "\n\n◆	Imagina un lugar tranquilo y sereno, como una playa o un bosque."
          "\n\n◆	Visualiza cada detalle: el sonido de las olas, el aroma de los árboles, la sensación de la brisa."
          "\n\n◆	Permítete sumergirte en esta escena, sintiendo que te envuelve la paz y la tranquilidad."
          "\n\n◆	Mantente en esta visualización durante 5-10 minutos."
    },
    {
      "title": "Afirmaciones para el Sueño",
      "instructions": "◆	Acuéstate en tu cama y cierra los ojos."
          "\n\n◆	Inhala profundamente y exhala lentamente."
          "\n\n◆	Repite afirmaciones como: “Estoy en paz”, “Me dejo llevar al sueño”, “Mi cuerpo está listo para descansar”."
          "\n\n◆	Siente la verdad de estas afirmaciones mientras las repites, permitiendo que te envuelvan en un estado de calma."
          "\n\n◆	Continúa esto durante 5-10 minutos."
    },
    {
      "title": "Atención Plena",
      "instructions": "◆	Acuéstate en una posición cómoda y cierra los ojos."
          "\n\n◆	Lleva tu atención a tu respiración. Observa cómo entra y sale el aire sin forzarla."
          "\n\n◆	Si tu mente divaga, simplemente redirige suavemente tu atención a la respiración."
          "\n\n◆	Haz esto durante 5-10 minutos, permitiendo que cada respiración te acerque más a un estado de relajación profunda."
    },
  ];

  final List<Map<String, String>> videos = [
    {"title": "Video 1 de Relajación", "url": "https://youtu.be/CkAOFDuxB38?si=ENjjRgHkelpzE4ld"},
    {"title": "Video 2 de Relajación", "url": "https://youtu.be/x0Ig8XNc8d8?si=LTgPK9ONaCB0Dg2h"},
    {"title": "Video 3 de Relajación", "url": "https://youtu.be/BTXcdQlXRJY?si=i5GsQ-GM47lm1NVe"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Ejercicios de Meditación'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const Text(
            'Meditaciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212529),
            ),
          ),
          const Gap(10), // Spacer
          // Meditations List
          ...meditations.map((meditation) => Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Color(0xFFCED4DA)),
                ),
                child: ListTile(
                  title: Text(
                    meditation["title"]!,
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Color(0xFF198754)),
                  onTap: () {
                    Get.to(MeditationDetailScreen(
                      title: meditation["title"]!,
                      instructions: meditation["instructions"]!,
                    ));
                  },
                ),
              )),

          const SizedBox(height: 30),
          // Additional Tips
          const Text(
            'Consejos Adicionales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212529),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8),
            child: MyText(
              '◆ Rutina: Intenta hacer estos ejercicios a la misma hora cada noche para establecer una rutina de relajación.\n'
              '◆ Ambiente: Asegúrate de que tu habitación esté oscura y tranquila, y considera usar música suave o sonidos de la naturaleza.\n'
              '◆ Desconexión: Apaga dispositivos electrónicos al menos 30 minutos antes de dormir para facilitar el proceso de relajación.',
              color: Color(0xFF6C757D),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'A continuación te brindamos más herramientas que te ayudaran a relajarte y a prepararte para un buen sueño:',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF212529),
            ),
          ),
          const SizedBox(height: 30),

          // Videos Section
          const Text(
            'Videos de Relajación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212529),
            ),
          ),
          const SizedBox(height: 10),
          // ...videos.map((video) => ListTile(
          //       leading: const Icon(Icons.play_circle_outline, color: Color(0xFF198754)),
          //       title: Text(video["title"]!, style: const TextStyle(color: Color(0xFF212529))),
          //       onTap: () => _launchURL(video["url"]!),
          //     )),
          ...videos.map((video) => Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Color(0xFFCED4DA)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.play_circle_outline, color: Color(0xFF198754)),
                  title: Text(
                    video["title"]!,
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Color(0xFF198754)),
                  onTap: () {
                    Get.to(MyVideoPlayer(url: video["url"]!, title: video["title"]!));
                  },
                ),
              )),
          const SizedBox(height: 10),
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
      appBar: AppBar(
        title: MyTitleAppBar(title: title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          instructions,
          style: const TextStyle(color: Color(0xFF6C757D), fontSize: 16, height: 1.2),
          textAlign: TextAlign.start,
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
  late YoutubePlayerController _controller;

  void listener() {
    if (_controller.value.playerState == PlayerState.ended) {
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Videos de Relajación'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Constants.kPrimaryColor,
                  progressColors: const ProgressBarColors(
                    playedColor: Constants.kBackgroundColor,
                    handleColor: Constants.kPrimaryColor,
                  ),
                  onReady: () {
                    _controller.addListener(listener);
                  },
                ),
              ),
              const Gap(15),
              MyText(
                widget.title,
                color: Color(0xFF212529),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const Gap(15),
              // About the Video
              Padding(
                padding: const EdgeInsets.all(10),
                child: MyText(
                  'Este video te ayudará a relajarte y a prepararte para un buen sueño. '
                  'Siéntate o acuéstate en una posición cómoda y disfruta de la experiencia.',
                  color: Color(0xFF6C757D),
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: MyText(
                  'Si te gusta el video te invitamos a suscribirte al canal del creador para más contenido de relajación. '
                  'Apoya a los cradores de contenido para que puedan seguir creando videos de relajación para ti y para el mundo.',
                  color: Color(0xFF6C757D),
                  textAlign: TextAlign.justify,
                ),
              ),
              const Gap(15),
              // Abrir en YouTube
              MyButton(
                text: 'Abrir en YouTube',
                onPressed: () => _launchURL(widget.url),
                color: Constants.kPrimaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/youtube.png', width: 32, height: 32),
                    Gap(10),
                    Text('Ver en YouTube', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
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
