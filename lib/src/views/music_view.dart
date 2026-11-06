import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicView extends StatefulWidget {
  const MusicView({super.key});

  @override
  State<MusicView> createState() => _MusicViewState();
}

class _MusicViewState extends State<MusicView> {
  Timer? _sleepTimer;
  int _remainingSeconds = 0;
  int _selectedMinutes = 0;

  final List<MusicCardData> musicData = [
    MusicCardData(
      title: 'Peaceful Piano',
      description: 'Hermosas piezas de piano acústico para la calma y el sueño.',
      imageUrl: 'https://i.scdn.co/image/ab67706f0000000283da657fca565320e9311863',
      link: 'https://open.spotify.com/playlist/37i9dQZF1DX4sWSpwq3LiO?si=3e9f7db161fa4dd4',
    ),
    MusicCardData(
      title: 'Nature Sounds',
      description: 'Sonidos inmersivos: lluvia suave, olas del mar y viento nocturno.',
      imageUrl: 'https://i.scdn.co/image/ab67706f00000002e909a20522cfdb017c798ba8',
      link: 'https://open.spotify.com/playlist/37i9dQZF1DX4PP3DA4J0N8?si=5fbffde6e8dc4f61',
    ),
    MusicCardData(
      title: 'Meditative Mind',
      description: 'Frecuencias armónicas para meditación y sueño profundo.',
      imageUrl: 'https://seed-mix-image.spotifycdn.com/v6/img/artist/1PTLyE54UyxphMo43yaSc7/es-419/default',
      link: 'https://open.spotify.com/playlist/37i9dQZF1EIXHxNW9W3Wef?si=07d8798603bd49cc',
    ),
    MusicCardData(
      title: 'Ambient Chill',
      description: 'Paisajes sonoros electrónicos suaves para desconectar la mente.',
      imageUrl: 'https://image-cdn-ak.spotifycdn.com/image/ab67706c0000d72c7cfb8d8736d7ec67b24670ca',
      link: 'https://open.spotify.com/playlist/1kqBP6eE24L0agNpnTIKtc?si=0673adc81d274ae3',
    ),
  ];

  @override
  void dispose() {
    _sleepTimer?.cancel();
    super.dispose();
  }

  void _startTimer(int minutes) {
    _sleepTimer?.cancel();
    HapticFeedback.selectionClick();
    if (minutes == 0) {
      setState(() {
        _selectedMinutes = 0;
        _remainingSeconds = 0;
      });
      return;
    }

    setState(() {
      _selectedMinutes = minutes;
      _remainingSeconds = minutes * 60;
    });

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        timer.cancel();
        HapticFeedback.mediumImpact();
        setState(() {
          _remainingSeconds = 0;
          _selectedMinutes = 0;
        });
        MySnackBar.showSnackBarSuccess('🌙 Tu temporizador nocturno ha finalizado. ¡Dulces sueños!');
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _formatCountdown(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

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
        title: const MyTitleAppBar(title: 'Música y Sonidos Relajantes'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Banner introductorio
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
                    Icon(Icons.headphones_rounded, color: Constants.kSecondaryColor, size: 24),
                    Gap(10),
                    MyText(
                      'Sonidos para Inducir el Sueño',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Constants.kTextColor,
                    ),
                  ],
                ),
                Gap(10),
                MyText(
                  'El ruido blanco y la música de baja frecuencia calman la actividad cerebral, reduciendo el tiempo necesario para quedarse dormido.',
                  fontSize: 13.5,
                  color: Constants.kTextSecondaryColor,
                ),
              ],
            ),
          ),
          const Gap(16),

          // Tarjeta de Temporizador de Relajación Nocturna (Sleep Timer)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Constants.kSurfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _remainingSeconds > 0
                    ? Constants.kMintColor.withValues(alpha: 0.5)
                    : Constants.kBorderColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: _remainingSeconds > 0 ? Constants.kMintColor : Constants.kSecondaryColor,
                          size: 22,
                        ),
                        const Gap(8),
                        const MyText(
                          'Temporizador de Desconexión',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Constants.kTextColor,
                        ),
                      ],
                    ),
                    if (_remainingSeconds > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Constants.kMintColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: MyText(
                          _formatCountdown(_remainingSeconds),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Constants.kMintColor,
                        ),
                      ),
                  ],
                ),
                const Gap(6),
                const MyText(
                  'Programa cuánto tiempo dedicarás a escuchar música o leer antes de cerrar los ojos:',
                  fontSize: 12.5,
                  color: Constants.kTextSecondaryColor,
                ),
                const Gap(12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [15, 30, 45, 60].map((min) {
                    final isSelected = _selectedMinutes == min && _remainingSeconds > 0;
                    return ChoiceChip(
                      label: MyText(
                        '$min min',
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Constants.kBackgroundColor : Constants.kTextColor,
                      ),
                      selected: isSelected,
                      selectedColor: Constants.kMintColor,
                      backgroundColor: Constants.kBackgroundColor,
                      side: BorderSide(
                        color: isSelected ? Constants.kMintColor : Constants.kBorderColor,
                      ),
                      onSelected: (_) => _startTimer(isSelected ? 0 : min),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const Gap(22),

          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: MyText(
              'Playlists recomendadas en Spotify',
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Constants.kTextColor,
            ),
          ),
          const Gap(14),

          // Grid moderno de tarjetas musicales
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemCount: musicData.length,
            itemBuilder: (context, index) {
              final item = musicData[index];
              return InkWell(
                onTap: () => _launchURL(item.link),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.kSurfaceColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Constants.kBorderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Constants.kSurfaceLightColor,
                                    child: const Center(
                                      child: Icon(Icons.music_note_rounded, color: Constants.kSecondaryColor, size: 36),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Constants.kMintColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              item.title,
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Constants.kTextColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Gap(4),
                            MyText(
                              item.description,
                              fontSize: 11.5,
                              color: Constants.kTextSecondaryColor,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Gap(24),
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
