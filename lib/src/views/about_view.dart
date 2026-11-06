import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
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
                boxShadow: [
                  BoxShadow(
                    color: Constants.kPrimaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Gap(14),
            const MyText(
              'Sleepfy',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Constants.kTextColor,
            ),
            const Gap(4),
            const MyText(
              'Versión ${Constants.appVersion}',
              fontSize: 13,
              color: Constants.kTextSecondaryColor,
            ),
            const Gap(24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Constants.kSurfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Constants.kBorderColor),
              ),
              child: const Column(
                children: [
                  MyText(
                    'Sleepfy es una plataforma diseñada para mejorar la calidad de vida y el bienestar a través del sueño reparador. Combina herramientas de relajación, higiene del sueño y análisis personalizado potenciado por Inteligencia Artificial.',
                    fontSize: 14.5,
                    color: Constants.kTextColor,
                    textAlign: TextAlign.center,
                  ),
                  Gap(16),
                  Divider(color: Constants.kBorderColor),
                  Gap(12),
                  MyText(
                    'Desarrollado con dedicación por Francisco Sotelo.',
                    fontSize: 13.5,
                    color: Constants.kTextSecondaryColor,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Gap(30),

            const SocialNetworkItem(
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
  final String? text;

  const SocialNetworkItem({super.key, required this.image, required this.url, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Constants.kSurfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Constants.kBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              width: 24,
              height: 24,
            ),
            if (text != null) ...[
              const Gap(12),
              MyText(
                text!,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Constants.kSecondaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
