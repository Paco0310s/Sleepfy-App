import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicView extends StatelessWidget {
  MusicView({super.key});

  final List<MusicCardData> musicData = [
    MusicCardData(
      title: 'Peaceful Piano',
      description: 'Hermosas piezas de piano para la calma.',
      imageUrl: 'https://i.scdn.co/image/ab67706f0000000283da657fca565320e9311863',
      link: 'https://open.spotify.com/playlist/37i9dQZF1DX4sWSpwq3LiO?si=3e9f7db161fa4dd4',
    ),
    MusicCardData(
      title: 'Nature Sounds',
      description: 'Sonidos naturales: lluvia, ríos y aves.',
      imageUrl: 'https://i.scdn.co/image/ab67706f00000002e909a20522cfdb017c798ba8',
      link: 'https://open.spotify.com/playlist/37i9dQZF1DX4PP3DA4J0N8?si=5fbffde6e8dc4f61',
    ),
    MusicCardData(
      title: 'Meditative Mind',
      description: 'Música para meditación y relajación profunda.',
      imageUrl: 'https://seed-mix-image.spotifycdn.com/v6/img/artist/1PTLyE54UyxphMo43yaSc7/es-419/default',
      link: 'https://open.spotify.com/playlist/37i9dQZF1EIXHxNW9W3Wef?si=07d8798603bd49cc',
    ),
    MusicCardData(
      title: 'Ambient Chill',
      description: 'Melodías suaves para desconectar.',
      imageUrl: 'https://image-cdn-ak.spotifycdn.com/image/ab67706c0000d72c7cfb8d8736d7ec67b24670ca',
      link: 'https://open.spotify.com/playlist/1kqBP6eE24L0agNpnTIKtc?si=0673adc81d274ae3',
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
        title: MyTitleAppBar(title: 'Música y sonidos relajantes'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'La música y los sonidos relajantes son perfectos para crear un ambiente de calma y bienestar antes de dormir. Aquí te damos algunas sugerencias:\n\n'
              '◆ Música instrumental: Pianistas como Ludovico Einaudi o Max Richter tienen piezas muy tranquilizadoras.\n'
              '◆ Sonidos de la naturaleza: Grabaciones de lluvia, olas del mar o cantos de pájaros pueden ser muy relajantes.\n'
              '◆ Música de meditación: Artistas como Deuter o Anoushka Shankar ofrecen melodías suaves ideales para la meditación.\n'
              '◆ Sonidos binaurales: Estas grabaciones pueden ayudar a inducir un estado de relajación profunda.\n\n'
              'Te presentamos algunas recomendaciones de listas de reproducción en Spotify que son perfectas para relajarse:',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF212529),
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          const Gap(20),
          Center(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: musicData.map((item) {
                return InkWell(
                  onTap: () => _launchURL(item.link),
                  child: Container(
                    width: 180,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFCED4DA), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            item.imageUrl,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/icon/icon.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212529),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                item.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6C757D),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Gap(20),
          // GridView.builder(
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     childAspectRatio: 0.8,
          //   ),
          //   itemCount: musicData.length,
          //   itemBuilder: (context, index) {
          //     final item = musicData[index];
          //     return Card(
          //       margin: EdgeInsets.all(10),
          //       elevation: 0,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //         side: BorderSide(color: Color(0xFFCED4DA), width: 1),
          //       ),
          //       child: InkWell(
          //         onTap: () => _launchURL(item.link),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Flexible(
          //               flex: 75,
          //               child: ClipRRect(
          //                 borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          //                 child: Container(
          //                   width: double.infinity,
          //                   color: Constants.kBackgroundColor,
          //                   child: Image.network(
          //                     item.imageUrl,
          //                     fit: BoxFit.cover,
          //                     errorBuilder: (context, error, stackTrace) {
          //                       return Image.asset(
          //                         'assets/icon/icon.png',
          //                         fit: BoxFit.cover,
          //                       );
          //                     },
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             Flexible(
          //               flex: 25,
          //               child: Padding(
          //                 padding: EdgeInsets.all(10),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(
          //                       item.title,
          //                       style: TextStyle(
          //                         fontSize: 20,
          //                         fontWeight: FontWeight.bold,
          //                         color: Color(0xFF212529),
          //                       ),
          //                     ),
          //                     SizedBox(height: 5),
          //                     Text(
          //                       item.description,
          //                       style: TextStyle(
          //                         fontSize: 15,
          //                         color: Color(0xFF6C757D),
          //                       ),
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
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
