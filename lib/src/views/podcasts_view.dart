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
      backgroundColor: Constants.kBackgroundColor,
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
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF1E1B4B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Constants.kPrimaryColor.withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.mic_none_rounded, color: Constants.kSecondaryColor, size: 24),
                    Gap(10),
                    MyText(
                      'Narrativa y Calma Auditiva',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Constants.kTextColor,
                    ),
                  ],
                ),
                Gap(10),
                MyText(
                  'Escuchar voces suaves y narraciones tranquilizadoras ayuda al cerebro a detener el monólogo interno de preocupaciones y facilitar la somnolencia natural.',
                  fontSize: 13.5,
                  color: Constants.kTextSecondaryColor,
                ),
              ],
            ),
          ),
          const Gap(22),

          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: MyText(
              'Podcasts seleccionados',
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Constants.kTextColor,
            ),
          ),
          const Gap(12),

          ...podcastList.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Constants.kSurfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Constants.kBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                onTap: () => _launchURL(item.link),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Constants.kMintColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.headphones_rounded,
                    color: Constants.kMintColor,
                    size: 24,
                  ),
                ),
                title: MyText(
                  item.title,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                  color: Constants.kTextColor,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: MyText(
                    item.description,
                    fontSize: 13,
                    color: Constants.kTextSecondaryColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.open_in_new_rounded,
                  color: Constants.kSecondaryColor,
                  size: 20,
                ),
              ),
            );
          }),
          const Gap(20),
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
