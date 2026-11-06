import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/login_view.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
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
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Perfil y Sesión'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(10),
              // Avatar minimalista
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.surface(context),
                  border: Border.all(color: Constants.border(context), width: 1.5),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 56,
                  color: Constants.accent(context),
                ),
              ),
              const Gap(16),
              MyText(
                fullName,
                color: Constants.textPrimary(context),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              const Gap(4),
              MyText(
                email ?? 'Sin correo electrónico',
                color: Constants.textSecondary(context),
                fontSize: 13.5,
              ),
              const Gap(28),

              // Tarjeta informativa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Constants.surface(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Constants.border(context)),
                ),
                child: Column(
                  children: [
                    _buildProfileItem(
                      context,
                      icon: Icons.person_outline_rounded,
                      label: 'Nombre completo',
                      value: fullName,
                    ),
                    Divider(height: 24, color: Constants.border(context)),
                    _buildProfileItem(
                      context,
                      icon: Icons.mail_outline_rounded,
                      label: 'Correo de acceso',
                      value: email ?? '-',
                    ),
                    Divider(height: 24, color: Constants.border(context)),
                    _buildProfileItem(
                      context,
                      icon: Icons.verified_user_outlined,
                      label: 'Estado de la cuenta',
                      value: 'Activa y verificada',
                      valueColor: Constants.kSageGreen,
                    ),
                  ],
                ),
              ),
              const Gap(28),

              // Cerrar sesión
              MyButton(
                outlined: true,
                text: 'Cerrar sesión',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Constants.kSoftRose, size: 19),
                    const Gap(8),
                    const MyText(
                      'Cerrar sesión',
                      color: Constants.kSoftRose,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ],
                ),
                onPressed: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Constants.surface(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: Constants.border(context)),
                        ),
                        title: const MyTitleAppBar(title: '¿Cerrar sesión?'),
                        content: MyText(
                          'Tendrás que volver a ingresar tus credenciales para acceder a tus rutinas y estadísticas.',
                          color: Constants.textSecondary(context),
                          fontSize: 13.5,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: MyText('Cancelar', color: Constants.textSecondary(context)),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await UserPreferences.logout();
                              Get.offAll(() => const LoginView());
                            },
                            child: const MyText('Cerrar sesión', color: Constants.kSoftRose, fontWeight: FontWeight.w600),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: Constants.textSecondary(context), size: 20),
        const Gap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                label,
                fontSize: 11.5,
                color: Constants.textSecondary(context),
              ),
              const Gap(2),
              MyText(
                value,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Constants.textPrimary(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
