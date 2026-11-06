import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class PodcastsView extends StatelessWidget {
  PodcastsView({super.key});

  final List<PodcastItemData> podcastList = [
    PodcastItemData(
      title: 'Durmiendo Podcast',
      description:
          'Ejercicios y meditaciones guiadas breves para reducir la ansiedad, calmar la mente y acompañarte en la transición al sueño.',
      link: 'https://open.spotify.com/show/1w9Me4TrRiDOuK3OsJ2VAW?si=79b3c58968764642',
    ),
    PodcastItemData(
      title: 'Dormicast',
      description:
          'Historias nocturnas, reflexiones serenas y ambientación sonora diseñadas para desviar los pensamientos del estrés diario.',
      link: 'https://open.spotify.com/show/4kC7b9omKVHMu6KPGd4sXV?si=151c55ef86e84bc7',
    ),
    PodcastItemData(
      title: 'Despertando + Durmiendo',
      description:
          'Rutinas de audio para irte a la cama en paz cada noche y comenzar tu mañana con calma y claridad.',
      link: 'https://www.youtube.com/@despertandodurmiendo',
    ),
  ];

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Podcasts de Relajación'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(18),
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
                    Icon(Icons.mic_none_rounded, color: Constants.accent(context), size: 22),
                    const Gap(10),
                    MyText(
                      'Narrativa y Calma Auditiva',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Constants.textPrimary(context),
                    ),
                  ],
                ),
                const Gap(8),
                MyText(
                  'Escuchar voces suaves y narraciones tranquilizadoras ayuda al cerebro a detener el monólogo interno de preocupaciones y facilitar la somnolencia natural.',
                  fontSize: 13,
                  color: Constants.textSecondary(context),
                  height: 1.45,
                ),
              ],
            ),
          ),
          const Gap(20),

          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: MyText(
              'Podcasts seleccionados',
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: Constants.textPrimary(context),
            ),
          ),
          const Gap(12),

          ...podcastList.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Constants.border(context)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                onTap: () => _launchURL(item.link),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Constants.surfaceLight(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.headphones_rounded,
                    color: Constants.kSageGreen,
                    size: 22,
                  ),
                ),
                title: MyText(
                  item.title,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Constants.textPrimary(context),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: MyText(
                    item.description,
                    fontSize: 12.5,
                    color: Constants.textSecondary(context),
                  ),
                ),
                trailing: Icon(
                  Icons.open_in_new_rounded,
                  color: Constants.textSecondary(context),
                  size: 18,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class PodcastItemData {
  final String title;
  final String description;
  final String link;

  PodcastItemData({
    required this.title,
    required this.description,
    required this.link,
  });
}
