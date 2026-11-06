import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Acerca de Sleepfy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: <Widget>[
            // Logo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Constants.border(context), width: 1.5),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Gap(14),
            MyText(
              'Sleepfy',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Constants.textPrimary(context),
            ),
            const Gap(4),
            MyText(
              'Versión ${Constants.appVersion}',
              fontSize: 12.5,
              color: Constants.textSecondary(context),
            ),
            const Gap(22),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Constants.border(context)),
              ),
              child: Column(
                children: [
                  MyText(
                    'Sleepfy es una plataforma diseñada para mejorar la calidad de vida y el bienestar a través del sueño reparador. Combina herramientas de relajación, higiene del sueño y análisis personalizado potenciado por Inteligencia Artificial.',
                    fontSize: 14,
                    color: Constants.textPrimary(context),
                    textAlign: TextAlign.center,
                    height: 1.5,
                  ),
                  const Gap(16),
                  Divider(color: Constants.border(context)),
                  const Gap(12),
                  MyText(
                    'Desarrollado con dedicación por Francisco Sotelo.',
                    fontSize: 13,
                    color: Constants.textSecondary(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Gap(26),

            SocialNetworkItem(
              image: 'assets/images/linkedin.png',
              url: 'https://www.linkedin.com/in/francisco-rafael-sotelo-delgado-4ba8a0254/',
              text: 'Conectar en LinkedIn',
            ),
            const Gap(30),
          ],
        ),
      ),
    );
  }
}

class SocialNetworkItem extends StatelessWidget {
  final String image;
  final String url;
  final String text;

  const SocialNetworkItem({super.key, required this.image, required this.url, required this.text});

  @override
  Widget build(BuildContext context) {
    return MyButton(
      outlined: true,
      text: text,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 20),
          const Gap(10),
          MyText(
            text,
            color: Constants.textPrimary(context),
            fontWeight: FontWeight.w500,
            fontSize: 13.5,
          ),
        ],
      ),
      onPressed: () {
        _launchURL(url);
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
