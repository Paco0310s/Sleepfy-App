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
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Acerca de'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sleepfy es una aplicación que te ayuda a dormir mejor. '
                'Con Sleepfy, puedes disfrutar de varias herramientas de relajación, '
                'meditación y sonidos de la naturaleza para ayudarte a dormir. ',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              Gap(20),
              Text(
                'Sleepfy fue desarrollado por Francisco Sotelo, '
                'Si tienes alguna pregunta o sugerencia, no dudes en '
                'contactarnos en:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SocialNetworkItem(
                      image: 'assets/images/linkedin.png',
                      url: 'https://www.linkedin.com/in/francisco-rafael-sotelo-delgado-4ba8a0254/',
                      text: 'Francisco Sotelo'),
                  // SizedBox(width: 50),
                  // SocialNetworkItem(
                  //   image: 'assets/images/instagram.png',
                  //   url: 'https://www.instagram.com/_sleepfy/',
                  //   text: 'Sleepfy',
                  // ),
                ],
              ),
              Gap(40),
              MyText(
                'Versión ${Constants.appVersion}',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              // Gap(20),
              // Text(
              //   '© 2024',
              //   style: TextStyle(fontSize: 16),
              // ),
              // Gap(20),
            ],
          ),
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
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Column(
        children: [
          Image.asset(
            image,
            width: 30,
            height: 30,
          ),
          if (text != null)
            SizedBox(
              width: 80,
              child: MyText(
                text!,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
