import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/about_view.dart';
import 'package:sleepfy/src/views/comments_view.dart';
import 'package:sleepfy/src/views/information_app_view.dart';
import 'package:sleepfy/src/views/information_kit_view.dart';
import 'package:sleepfy/src/views/information_sesion_view.dart';
import 'package:sleepfy/src/views/login_view.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Ajustes'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Información de la sesión'),
            onTap: () {
              Get.to(() => const InformationSesionView());
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Información sobre el insomnio'),
            onTap: () {
              Get.to(() => const InformationAppView());
            },
          ),
          ListTile(
            leading: const Icon(FeatherIcons.activity),
            title: const Text('Información del kit'),
            onTap: () {
              Get.to(() => InformationKitView());
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.play_arrow),
          //   title: const Text('Crea tu rutina personalizada'),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Comunidad'),
            onTap: () {
              Get.to(() => const CommentsView());
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Acerca de'),
            onTap: () {
              Get.to(() => const AboutView());
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              UserPreferences.removeToken();
              UserPreferences.removeId();
              Get.offAll(() => const LoginView());
            },
          ),
        ],
      ),
    );
  }
}
