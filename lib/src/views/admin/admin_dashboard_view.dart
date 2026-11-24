import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/views/admin/admin_content_config.dart';
import 'package:sleepfy/src/views/admin/admin_content_list_view.dart';
import 'package:sleepfy/src/views/admin/admin_kit_products_view.dart';
import 'package:sleepfy/src/views/admin/admin_metrics_view.dart';
import 'package:sleepfy/src/views/admin/admin_test_editor_view.dart';
import 'package:sleepfy/src/views/admin/admin_users_view.dart';
import 'package:sleepfy/src/views/comments_view.dart';
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
            subtitle: 'Crear, editar, gestionar stock, imágenes y enlaces de compra del Kit.',
            onTap: () => Get.to(() => const AdminKitProductsView()),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.menu_book_outlined,
            iconColor: Constants.accent(context),
            title: 'Información sobre el Insomnio',
            subtitle: 'Editar tarjetas educativas y enlaces médicos recomendados.',
            onTap: () => Get.to(() => const AdminContentListView(
                  title: 'Info sobre el Insomnio',
                  sections: [
                    AdminSectionConfigs.insomniaCard,
                    AdminSectionConfigs.insomniaLink,
                  ],
                )),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.self_improvement_rounded,
            iconColor: Constants.kSageGreen,
            title: 'Meditaciones y Videos',
            subtitle: 'Gestionar ejercicios guiados y sesiones en video de YouTube.',
            onTap: () => Get.to(() => const AdminContentListView(
                  title: 'Meditaciones y Videos',
                  sections: [
                    AdminSectionConfigs.meditation,
                    AdminSectionConfigs.meditationVideo,
                  ],
                )),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.music_note_rounded,
            iconColor: Constants.accent(context),
            title: 'Música y Playlists',
            subtitle: 'Administrar playlists recomendadas, portadas y enlaces.',
            onTap: () => Get.to(() => const AdminContentListView(
                  title: 'Música y Playlists',
                  sections: [AdminSectionConfigs.music],
                )),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.headphones_rounded,
            iconColor: Constants.kSageGreen,
            title: 'Podcasts de Relajación',
            subtitle: 'Editar podcasts recomendados y sus enlaces externos.',
            onTap: () => Get.to(() => const AdminContentListView(
                  title: 'Podcasts de Relajación',
                  sections: [AdminSectionConfigs.podcast],
                )),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.emoji_events_outlined,
            iconColor: Constants.kSoftAmber,
            title: 'Desafíos de Sueño',
            subtitle: 'Agregar, modificar u ocultar retos semanales de descanso.',
            onTap: () => Get.to(() => const AdminContentListView(
                  title: 'Desafíos de Sueño',
                  sections: [AdminSectionConfigs.challenge],
                )),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.campaign_outlined,
            iconColor: Constants.kSoftAmber,
            title: 'Avisos y Banners en Inicio',
            subtitle: 'Publicar u ocultar anuncios temporales en la pantalla principal.',
            onTap: () => Get.to(() => const AdminContentListView(
                  title: 'Avisos en Inicio',
                  sections: [AdminSectionConfigs.homeBanner],
                )),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.quiz_outlined,
            iconColor: Constants.kSageGreen,
            title: 'Editor del Test de Sueño',
            subtitle: 'Agregar, editar o eliminar preguntas y opciones de respuesta.',
            onTap: () => Get.to(() => const AdminTestEditorView()),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.manage_accounts_outlined,
            iconColor: Constants.accent(context),
            title: 'Gestión de Administradores',
            subtitle: 'Buscar usuarios y otorgar o revocar permisos de administrador.',
            onTap: () => Get.to(() => const AdminUsersView()),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.bar_chart_rounded,
            iconColor: Constants.kSoftAmber,
            title: 'Métricas y Reportes',
            subtitle: 'Estadísticas de usuarios, rutinas IA, test, inventario y registros.',
            onTap: () => Get.to(() => const AdminMetricsView()),
          ),
          const Gap(12),

          _AdminModuleCard(
            icon: Icons.forum_outlined,
            iconColor: Constants.kSoftAmber,
            title: 'Comunidad Sleepfy (Moderar)',
            subtitle: 'Revisar y eliminar comentarios inapropiados o spam.',
            onTap: () => Get.to(() => const CommentsView()),
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
  final VoidCallback? onTap;

  const _AdminModuleCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Constants.border(context)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
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
              Icon(
                Icons.chevron_right_rounded,
                color: Constants.textSecondary(context),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
