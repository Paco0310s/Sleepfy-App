import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationAppView extends StatelessWidget {
  const InformationAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Conoce más sobre el insomnio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              context,
              title: '¿Qué es el Insomnio?',
              icon: Icons.help_outline_rounded,
              iconColor: Constants.accent(context),
              content:
                  'El insomnio es un trastorno del sueño caracterizado por la dificultad para conciliar el sueño, mantenerse dormido o lograr un descanso verdaderamente reparador. Puede manifestarse de forma aguda (corto plazo) o crónica (más de 3 meses).',
            ),
            const Gap(12),
            _buildInfoCard(
              context,
              title: 'Características del Insomnio',
              icon: Icons.warning_amber_rounded,
              iconColor: const Color(0xFFD49E3D),
              content:
                  '◆ Dificultad para conciliar el sueño (tardar más de 30 minutos).\n'
                  '◆ Despertares frecuentes e interrupciones durante la noche.\n'
                  '◆ Despertarse mucho antes de lo deseado sin poder volver a dormir.\n'
                  '◆ Sensación de sueño no reparador y cansancio diurno.',
            ),
            const Gap(12),
            _buildInfoCard(
              context,
              title: '¿Cómo Afecta el Insomnio?',
              icon: Icons.healing_rounded,
              iconColor: Constants.kSoftRose,
              content:
                  '◆ Fatiga persistente y bajo nivel de energía.\n'
                  '◆ Dificultad para concentrarse y problemas de retención o memoria.\n'
                  '◆ Mayor irritabilidad, ansiedad y fluctuaciones del estado de ánimo.\n'
                  '◆ Disminución en la respuesta del sistema inmunológico.',
            ),
            const Gap(12),
            _buildInfoCard(
              context,
              title: 'La Importancia Vital del Sueño',
              icon: Icons.spa_rounded,
              iconColor: Constants.kSageGreen,
              content:
                  'Durante las fases profundas del sueño se regulan hormonas clave como la melatonina y el cortisol, se restauran las células y el cerebro consolida los recuerdos y aprendizajes del día.',
            ),
            const Gap(22),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: MyText(
                'Fuentes y recursos médicos recomendados',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Constants.textPrimary(context),
              ),
            ),
            const Gap(10),
            const LinkButton(
              title: 'MedlinePlus en Español',
              url: 'https://medlineplus.gov/spanish/',
            ),
            const LinkButton(
              title: 'Mayo Clinic - Trastornos del Sueño',
              url: 'https://www.mayoclinic.org/es-es/',
            ),
            const LinkButton(
              title: 'National Sleep Foundation (NSF)',
              url: 'https://www.sleepfoundation.org/',
            ),
            const LinkButton(
              title: 'CDC - Salud y Sueño',
              url: 'https://www.cdc.gov/sleep/index.html',
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const Gap(12),
              Expanded(
                child: MyText(
                  title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Constants.textPrimary(context),
                ),
              ),
            ],
          ),
          const Gap(10),
          MyText(
            content,
            fontSize: 13.5,
            color: Constants.textSecondary(context),
            height: 1.45,
          ),
        ],
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  final String title;
  final String url;

  const LinkButton({super.key, required this.title, required this.url});

  Future<void> _launchURL() async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: MyButton(
        outlined: true,
        text: title,
        onPressed: _launchURL,
        child: Row(
          children: [
            Expanded(
              child: MyText(
                title,
                color: Constants.textPrimary(context),
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
              ),
            ),
            const Gap(10),
            Icon(
              Icons.open_in_new_rounded,
              color: Constants.textSecondary(context),
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}
