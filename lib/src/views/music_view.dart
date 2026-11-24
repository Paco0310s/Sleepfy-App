import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/controllers/content_controller.dart';
import 'package:sleepfy/models/content_item_model.dart';
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

  List<ContentItemModel> _musicList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final list = await ContentController.getActiveBySection(ContentSections.music);
    if (!mounted) return;
    setState(() {
      _musicList = list;
      _isLoading = false;
    });
  }

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
      MySnackBar.showSnackBarSuccess('Temporizador cancelado');
      return;
    }

    setState(() {
      _selectedMinutes = minutes;
      _remainingSeconds = minutes * 60;
    });

    MySnackBar.showSnackBarSuccess('Temporizador activado por $minutes minutos');

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
          _selectedMinutes = 0;
        });
        HapticFeedback.heavyImpact();
        MySnackBar.showSnackBarSuccess('¡Tiempo de desconexión terminado! Es hora de dormir');
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _formatCountdown(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _launchURL(String? url) async {
    final trimmed = url?.trim() ?? '';
    if (trimmed.isEmpty) {
      MySnackBar.showSnackBarError('Enlace no disponible');
      return;
    }
    final Uri? uri = Uri.tryParse(trimmed);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      MySnackBar.showSnackBarError('No se pudo abrir el enlace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Música y Sonidos Relajantes'),
      ),
      body: RefreshIndicator(
        color: Constants.kSageGreen,
        onRefresh: _loadContent,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            // Banner introductorio
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
                      Icon(Icons.headphones_rounded, color: Constants.accent(context), size: 22),
                      const Gap(10),
                      MyText(
                        'Sonidos para Inducir el Sueño',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                    ],
                  ),
                  const Gap(8),
                  MyText(
                    'El ruido blanco y la música de baja frecuencia calman la actividad cerebral, reduciendo el tiempo necesario para quedarse dormido.',
                    fontSize: 13,
                    color: Constants.textSecondary(context),
                    height: 1.45,
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Tarjeta de Temporizador de Relajación Nocturna
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _remainingSeconds > 0
                      ? Constants.kSageGreen.withValues(alpha: 0.6)
                      : Constants.border(context),
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
                            color: _remainingSeconds > 0 ? Constants.kSageGreen : Constants.accent(context),
                            size: 20,
                          ),
                          const Gap(8),
                          MyText(
                            'Temporizador de Desconexión',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: Constants.textPrimary(context),
                          ),
                        ],
                      ),
                      if (_remainingSeconds > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Constants.kSageGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MyText(
                            _formatCountdown(_remainingSeconds),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Constants.kSageGreen,
                          ),
                        ),
                    ],
                  ),
                  const Gap(6),
                  MyText(
                    'Programa cuánto tiempo dedicarás a escuchar música antes de cerrar los ojos:',
                    fontSize: 12,
                    color: Constants.textSecondary(context),
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
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? Constants.primaryContent(context) : Constants.textPrimary(context),
                        ),
                        selected: isSelected,
                        selectedColor: Constants.primary(context),
                        backgroundColor: Constants.surfaceLight(context),
                        side: BorderSide(color: isSelected ? Colors.transparent : Constants.border(context)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        onSelected: (_) => _startTimer(min),
                      );
                    }).toList()
                      ..add(
                        ChoiceChip(
                          label: MyText(
                            'Apagar',
                            fontSize: 12,
                            color: Constants.textSecondary(context),
                          ),
                          selected: false,
                          backgroundColor: Constants.surfaceLight(context),
                          side: BorderSide(color: Constants.border(context)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          onSelected: (_) => _startTimer(0),
                        ),
                      ),
                  ),
                ],
              ),
            ),
            const Gap(22),

            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: MyText(
                'Playlists recomendadas en Spotify',
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: Constants.textPrimary(context),
              ),
            ),
            const Gap(12),

            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(child: CircularProgressIndicator(color: Constants.primary(context))),
              )
            else
              ..._musicList.map((data) => _MusicCard(
                    data: data,
                    onTap: () => _launchURL(data.url),
                  )),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

class _MusicCard extends StatelessWidget {
  final ContentItemModel data;
  final VoidCallback onTap;

  const _MusicCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = data.resolvedImageUrl ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Constants.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Constants.border(context)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderThumb(context),
                    )
                  : _placeholderThumb(context),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    data.title,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Constants.textPrimary(context),
                  ),
                  if ((data.subtitle ?? '').isNotEmpty) ...[
                    const Gap(3),
                    MyText(
                      data.subtitle!,
                      fontSize: 12,
                      color: Constants.textSecondary(context),
                    ),
                  ],
                ],
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Constants.surfaceLight(context),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Constants.kSageGreen, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderThumb(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      color: Constants.surfaceLight(context),
      child: Icon(Icons.music_note, color: Constants.accent(context)),
    );
  }
}
