import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/views/admin/admin_kit_products_view.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Panel de Administrador'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Constants.surface(context),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Constants.border(context)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: Constants.kSageGreen.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Constants.kSageGreen,
                    size: 24,
                  ),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        'Gestión de contenido',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                      const Gap(3),
                      MyText(
                        'Administra los módulos dinámicos de Sleepfy de forma segura.',
                        fontSize: 12.5,
                        color: Constants.textSecondary(context),
                        height: 1.35,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),

          _AdminModuleCard(
            icon: Icons.inventory_2_outlined,
            iconColor: Constants.kSageGreen,
            title: 'Productos del Kit Sleepfy',
            subtitle: 'Crear, editar, gestionar stock, imágenes y visibilidad de los productos.',
            onTap: () => Get.to(() => const AdminKitProductsView()),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.bar_chart_rounded,
            iconColor: Constants.textSecondary(context),
            title: 'Métricas y Reportes',
            subtitle: 'Próximamente: estadísticas de uso, evaluaciones y usuarios.',
            enabled: false,
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class _AdminModuleCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  const _AdminModuleCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.55,
      child: Container(
        decoration: BoxDecoration(
          color: Constants.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Constants.border(context)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        title,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                      const Gap(4),
                      MyText(
                        subtitle,
                        fontSize: 12,
                        color: Constants.textSecondary(context),
                        height: 1.35,
                      ),
                    ],
                  ),
                ),
                if (enabled)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Constants.textSecondary(context),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
