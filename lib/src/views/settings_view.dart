import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/about_view.dart';
import 'package:sleepfy/src/views/comments_view.dart';
import 'package:sleepfy/src/views/information_app_view.dart';
import 'package:sleepfy/src/views/information_kit_view.dart';
import 'package:sleepfy/src/views/information_sesion_view.dart';
import 'package:sleepfy/src/views/login_view.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Ajustes y Cuenta'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _buildSectionHeader('CUENTA Y PERFIL'),
          _SettingsGroupContainer(
            children: [
              _SettingsTile(
                icon: Icons.person_outline_rounded,
                iconColor: Constants.kPrimaryColor,
                title: 'Información de la sesión',
                onTap: () => Get.to(() => const InformationSesionView()),
              ),
            ],
          ),
          const Gap(20),

          _buildSectionHeader('BIENESTAR Y RECURSOS'),
          _SettingsGroupContainer(
            children: [
              _SettingsTile(
                icon: Icons.menu_book_outlined,
                iconColor: Constants.kSecondaryColor,
                title: 'Información sobre el insomnio',
                onTap: () => Get.to(() => const InformationAppView()),
              ),
              const Divider(height: 1, indent: 56, endIndent: 16),
              _SettingsTile(
                icon: Icons.inventory_2_outlined,
                iconColor: Constants.kMintColor,
                title: 'Detalles del Kit Sleepfy',
                onTap: () => Get.to(() => InformationKitView()),
              ),
              const Divider(height: 1, indent: 56, endIndent: 16),
              _SettingsTile(
                icon: Icons.forum_outlined,
                iconColor: const Color(0xFFF59E0B),
                title: 'Comunidad Sleepfy',
                onTap: () => Get.to(() => const CommentsView()),
              ),
            ],
          ),
          const Gap(20),

          _buildSectionHeader('APLICACIÓN'),
          _SettingsGroupContainer(
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                iconColor: Constants.kTextSecondaryColor,
                title: 'Acerca de Sleepfy',
                onTap: () => Get.to(() => const AboutView()),
              ),
              const Divider(height: 1, indent: 56, endIndent: 16),
              _SettingsTile(
                icon: Icons.logout_rounded,
                iconColor: Constants.kErrorColor,
                title: 'Cerrar sesión',
                textColor: Constants.kErrorColor,
                showArrow: false,
                onTap: () async {
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
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 8),
      child: MyText(
        title,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Constants.kTextSecondaryColor,
      ),
    );
  }
}

class _SettingsGroupContainer extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroupContainer({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.kSurfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Constants.kBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? textColor;
  final bool showArrow;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.textColor,
    this.showArrow = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: MyText(
        title,
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
        color: textColor ?? Constants.kTextColor,
      ),
      trailing: showArrow
          ? const Icon(
              Icons.chevron_right_rounded,
              color: Constants.kTextSecondaryColor,
              size: 20,
            )
          : null,
      onTap: onTap,
    );
  }
}
