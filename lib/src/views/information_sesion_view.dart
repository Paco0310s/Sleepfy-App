import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
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
      backgroundColor: Constants.kBackgroundColor,
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
              // Avatar estilizado
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.kSurfaceColor,
                  border: Border.all(color: Constants.kPrimaryColor.withValues(alpha: 0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Constants.kPrimaryColor.withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 64,
                  color: Constants.kSecondaryColor,
                ),
              ),
              const Gap(20),
              MyText(
                fullName,
                color: Constants.kTextColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              const Gap(6),
              MyText(
                email ?? 'Sin correo electrónico',
                color: Constants.kTextSecondaryColor,
                fontSize: 14,
              ),
              const Gap(32),

              // Tarjeta informativa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Constants.kSurfaceColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Constants.kBorderColor),
                ),
                child: Column(
                  children: [
                    _buildProfileItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Nombre completo',
                      value: fullName,
                    ),
                    const Divider(height: 24, color: Constants.kBorderColor),
                    _buildProfileItem(
                      icon: Icons.mail_outline_rounded,
                      label: 'Correo de acceso',
                      value: email ?? '-',
                    ),
                    const Divider(height: 24, color: Constants.kBorderColor),
                    _buildProfileItem(
                      icon: Icons.verified_user_outlined,
                      label: 'Estado de la cuenta',
                      value: 'Activa y sincronizada',
                      valueColor: Constants.kMintColor,
                    ),
                  ],
                ),
              ),
              const Gap(40),

              // Botón cerrar sesión
              MyButton(
                color: Constants.kErrorColor.withValues(alpha: 0.85),
                text: 'Cerrar Sesión',
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                    Gap(8),
                    MyText(
                      'Cerrar Sesión',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                onPressed: () async {
                  await UserPreferences.logout();
                  if (context.mounted) {
                    Provider.of<TestProvider>(context, listen: false).reset();
                    Provider.of<ControlDreamsProvider>(context, listen: false).reset();
                  }
                  Get.offAll(() => const LoginView());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: Constants.kSecondaryColor, size: 20),
        const Gap(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              label,
              fontSize: 12,
              color: Constants.kTextSecondaryColor,
            ),
            const Gap(2),
            MyText(
              value,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Constants.kTextColor,
            ),
          ],
        ),
      ],
    );
  }
}
