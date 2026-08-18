import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class PodcastsView extends StatelessWidget {
  PodcastsView({super.key});

  final List<MusicCardData> musicData = [
    MusicCardData(
      title: 'Durmiendo',
      description:
          'Durmiendo es un podcast que te ayudará a relajarte y a conciliar el sueño a través de ejercicios y meditaciones que te ayudarán a reducir tu ansiedad y tu estrés.',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273f3b3b3b3b3b3b3b3b3b3b3b3',
      link: 'https://open.spotify.com/show/1w9Me4TrRiDOuK3OsJ2VAW?si=79b3c58968764642',
    ),
    MusicCardData(
      title: 'Dormicast',
      description:
          'Dormicast es un podcast en español diseñado para ayudar a conciliar el sueño. Ofrece cuentos, meditaciones y sonidos relajantes, todo pensado para crear un ambiente propicio para descansar.',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273f3b3b3b3b3b3b3b3b3b3b3',
      link: 'https://open.spotify.com/show/4kC7b9omKVHMu6KPGd4sXV?si=151c55ef86e84bc7',
    ),
    MusicCardData(
      title: 'Despertando + Durmiendo Podcast',
      description:
          'A través de reflexiones, ejercicios de relajación, meditaciones guiadas y más, podrás despertar con energía e irte a la cama con total tranquilidad.',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273f3b3b3b3b3b3b3b3b3b3b3',
      link: 'http://www.youtube.com/@despertandodurmiendo',
    ),
  ];

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyTitleAppBar(title: 'Podcasts de relajación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Los podcasts relajantes ayudan a conciliar el sueño al crear un ambiente tranquilo con narraciones suaves, '
                'desviar la mente de pensamientos estresantes, establecer una rutina nocturna que indique al cuerpo que es '
                'hora de descansar, además de incluir técnicas de relajación, como ejercicios de respiración e inducir un '
                'estado de relajación con sonidos suaves y música. '
                '\n\nExperimentar con diferentes estilos puede ayudarte a encontrar lo que mejor te funcione. '
                '\nTe brindamos algunas recomendaciones de podcasts relajantes que pueden ayudarte a desconectar y encontrar calma:',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF212529),
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const Gap(15),
            ...musicData.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFCED4DA), width: 1),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    onTap: () => _launchURL(item.link),
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: const Icon(Icons.play_circle_outline, color: Color(0xFF198754)),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: Color(0xFF212529),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      item.description,
                      style: TextStyle(
                        color: Color(0xFF6C757D),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              );
            }),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

class MusicCardData {
  final String title;
  final String description;
  final String imageUrl;
  final String link;

  MusicCardData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.link,
  });
}
