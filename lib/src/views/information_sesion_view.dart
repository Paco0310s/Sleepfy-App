import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/login_view.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class InformationSesionView extends StatelessWidget {
  const InformationSesionView({super.key});

  @override
  Widget build(BuildContext context) {
    final name = UserPreferences.name?.trim() ?? 'INVITADO';
    final lastName = UserPreferences.lastName?.trim() ?? '';
    final fullName = '$name $lastName';
    final email = UserPreferences.email;

    return Scaffold(
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Información de la Sesión'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto de perfil
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(10),
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Constants.kBackgroundColor,
                    width: 1,
                  ),
                ),
                child: Icon(
                  FeatherIcons.user,
                  size: 100,
                  color: Constants.kPrimaryColor,
                ),
              ),
              // Nombre
              const SizedBox(height: 20),
              Text(
                fullName,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              // Email
              Text(
                email ?? 'Sin correo',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 40),
              // Cerrar sesión
              MyButton(
                  text: 'Cerrar Sesión',
                  onPressed: () {
                    UserPreferences.removeToken();
                    UserPreferences.removeId();
                    Get.offAll(() => const LoginView());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
