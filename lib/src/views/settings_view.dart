import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/providers/theme_provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Ajustes y Cuenta'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _buildSectionHeader(context, 'APARIENCIA'),
          _SettingsGroupContainer(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Constants.surfaceLight(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: Constants.accent(context),
                    size: 20,
                  ),
                ),
                title: MyText(
                  'Tema oscuro',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: Constants.textPrimary(context),
                ),
                subtitle: MyText(
                  themeProvider.isDarkMode
                      ? 'Gris slate sereno (modo noche)'
                      : 'Blanco cálido suave (modo día)',
                  fontSize: 12,
                  color: Constants.textSecondary(context),
                ),
                trailing: Switch.adaptive(
                  value: themeProvider.isDarkMode,
                  activeTrackColor: Constants.kSageGreen,
                  onChanged: (val) => themeProvider.setDarkMode(val),
                ),
              ),
            ],
          ),
          const Gap(20),

          _buildSectionHeader(context, 'CUENTA Y PERFIL'),
          _SettingsGroupContainer(
            children: [
              _SettingsTile(
                icon: Icons.person_outline_rounded,
                iconColor: Constants.accent(context),
                title: 'Información de la sesión',
                onTap: () => Get.to(() => const InformationSesionView()),
              ),
            ],
          ),
          const Gap(20),

          _buildSectionHeader(context, 'BIENESTAR Y RECURSOS'),
          _SettingsGroupContainer(
            children: [
              _SettingsTile(
                icon: Icons.menu_book_outlined,
                iconColor: Constants.accent(context),
                title: 'Información sobre el insomnio',
                onTap: () => Get.to(() => const InformationAppView()),
              ),
              Divider(height: 1, indent: 56, endIndent: 16, color: Constants.border(context)),
              _SettingsTile(
                icon: Icons.inventory_2_outlined,
                iconColor: Constants.kSageGreen,
                title: 'Detalles del Kit Sleepfy',
                onTap: () => Get.to(() => InformationKitView()),
              ),
              Divider(height: 1, indent: 56, endIndent: 16, color: Constants.border(context)),
              _SettingsTile(
                icon: Icons.forum_outlined,
                iconColor: Constants.kSoftAmber,
                title: 'Comunidad Sleepfy',
                onTap: () => Get.to(() => const CommentsView()),
              ),
            ],
          ),
          const Gap(20),

          _buildSectionHeader(context, 'APLICACIÓN'),
          _SettingsGroupContainer(
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                iconColor: Constants.textSecondary(context),
                title: 'Acerca de Sleepfy',
                onTap: () => Get.to(() => const AboutView()),
              ),
              Divider(height: 1, indent: 56, endIndent: 16, color: Constants.border(context)),
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 8),
      child: MyText(
        title,
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: Constants.textSecondary(context),
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
        color: Constants.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Constants.border(context), width: 1),
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
          color: Constants.surfaceLight(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: MyText(
        title,
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
        color: textColor ?? Constants.textPrimary(context),
      ),
      trailing: showArrow
          ? Icon(
              Icons.chevron_right_rounded,
              color: Constants.textSecondary(context),
              size: 20,
            )
          : null,
      onTap: onTap,
    );
  }
}
