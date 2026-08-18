import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/views/challenges_view.dart';
import 'package:sleepfy/src/views/control_dreams_view.dart';
import 'package:sleepfy/src/views/meditations_view.dart';
import 'package:sleepfy/src/views/music_view.dart';
import 'package:sleepfy/src/views/podcasts_view.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class ToolsView extends StatelessWidget {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Opciones'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(FeatherIcons.bookOpen),
            title: const Text('Ejercicios de meditación o respiración guiada'),
            onTap: () {
              Get.to(() => MeditationsView());
            },
          ),
          ListTile(
            leading: const Icon(FeatherIcons.music),
            title: const Text('Música y sonidos relajantes'),
            onTap: () {
              Get.to(() => MusicView());
            },
          ),
          ListTile(
            leading: const Icon(FeatherIcons.headphones),
            title: const Text('Podcasts de relajación'),
            onTap: () {
              Get.to(() => PodcastsView());
            },
          ),
          ListTile(
            leading: const Icon(FeatherIcons.sunrise),
            title: const Text('Desafíos/Logros de sueño'),
            onTap: () {
              Get.to(() => ChallengesView());
            },
          ),
          ListTile(
            leading: const Icon(FeatherIcons.sun),
            title: const Text('Control de ciclos de sueño'),
            onTap: () {
              Get.to(() => const ControlDreamsView());
            },
          ),
        ],
      ),
    );
  }
}
