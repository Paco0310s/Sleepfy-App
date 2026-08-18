import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationAppView extends StatelessWidget {
  const InformationAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyTitleAppBar(title: 'Conoce más sobre el insomnio'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: '¿Qué es el Insomnio?'),
            Text(
              'El insomnio es un trastorno del sueño caracterizado por la dificultad para quedarse dormido, mantenerse dormido o lograr un sueño reparador. Puede ser de corta duración (insomnio agudo) o durar mucho tiempo (insomnio crónico).',
              style: TextStyle(color: Color(0xFF6C757D), fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SectionTitle(title: 'Características del Insomnio'),
            SectionContent(
              content: '◆ Dificultad para conciliar el sueño: Puede tardarse más de 30 minutos en quedarse dormido.\n'
                  '◆ Despertares frecuentes durante la noche.\n'
                  '◆ Despertarse demasiado temprano.\n'
                  '◆ Sueño no reparador.',
            ),
            SectionTitle(title: '¿Cómo Afecta el Insomnio?'),
            SectionContent(
              content: '◆ Fatiga y Cansancio.\n'
                  '◆ Problemas de Concentración y Memoria.\n'
                  '◆ Irritabilidad y Cambios de Humor.\n'
                  '◆ Afectación en el Sistema Inmune.\n'
                  '◆ Riesgo de Problemas de Salud Crónicos.',
            ),
            SectionTitle(title: 'La Importancia del Sueño'),
            SectionContent(
              content:
                  'El sueño es un proceso biológico esencial para la salud y el bienestar. Durante el sueño, el cuerpo y la mente pasan por procesos de recuperación vitales:\n'
                  '◆ Reparación y Crecimiento.\n'
                  '◆ Procesamiento Emocional y Memoria.\n'
                  '◆ Regulación Hormonal.\n'
                  '◆ Desempeño Físico y Mental.',
            ),
            const Gap(20),
            SectionTitle(title: 'Para conocer más al respecto:'),
            LinkButton(
              title: 'MedlinePlus',
              url: 'https://medlineplus.gov/spanish/',
            ),
            LinkButton(
              title: 'Mayo Clinic',
              url: 'https://www.mayoclinic.org/es-es/',
            ),
            LinkButton(
              title: 'National Sleep Foundation (NSF)',
              url: 'https://www.sleepfoundation.org/',
            ),
            LinkButton(
              title: 'CDC - Centros para el Control y la Prevención de Enfermedades',
              url: 'https://www.cdc.gov/sleep/index.html',
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          color: Color(0xFF212529),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

class SectionContent extends StatelessWidget {
  final String content;

  const SectionContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(color: Color(0xFF6C757D), fontSize: 16),
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
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: MyButton(
        text: title,
        onPressed: _launchURL,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Gap(20),
            Icon(
              Icons.open_in_new,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
