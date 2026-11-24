import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/controllers/admin_controller.dart';
import 'package:sleepfy/models/admin_models.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class AdminMetricsView extends StatefulWidget {
  const AdminMetricsView({super.key});

  @override
  State<AdminMetricsView> createState() => _AdminMetricsViewState();
}

class _AdminMetricsViewState extends State<AdminMetricsView> {
  AdminMetricsModel? _metrics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    final data = await AdminController.getMetrics();
    if (!mounted) return;
    setState(() {
      _metrics = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Métricas y Reportes'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Constants.primary(context)))
          : _metrics == null
              ? RefreshIndicator(
                  color: Constants.kSageGreen,
                  onRefresh: _loadMetrics,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                        child: Center(
                          child: MyText(
                            'No se pudieron cargar las métricas en este momento. Desliza para reintentar.',
                            fontSize: 13.5,
                            color: Constants.textSecondary(context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: Constants.kSageGreen,
                  onRefresh: _loadMetrics,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    children: [
                      _SectionTitle(
                        title: 'Usuarios y Crecimiento',
                        trailing: 'Últimos 30d: +${_metrics!.newUsersLast30Days}',
                      ),
                      const Gap(10),
                      _KpiGrid(
                        items: [
                          _KpiData(
                            label: 'Total usuarios',
                            value: _metrics!.totalUsers.toString(),
                            icon: Icons.people_outline_rounded,
                            color: Constants.accent(context),
                          ),
                          _KpiData(
                            label: 'Verificados',
                            value: _metrics!.verifiedUsers.toString(),
                            icon: Icons.verified_user_outlined,
                            color: Constants.kSageGreen,
                          ),
                          _KpiData(
                            label: 'Nuevos (7 días)',
                            value: '+${_metrics!.newUsersLast7Days}',
                            icon: Icons.trending_up_rounded,
                            color: Constants.kSageGreen,
                          ),
                          _KpiData(
                            label: 'Administradores',
                            value: _metrics!.totalAdmins.toString(),
                            icon: Icons.admin_panel_settings_outlined,
                            color: Constants.kSoftAmber,
                          ),
                        ],
                      ),
                      const Gap(20),

                      const _SectionTitle(title: 'Actividad y Uso'),
                      const Gap(10),
                      _KpiGrid(
                        items: [
                          _KpiData(
                            label: 'Rutinas IA',
                            value: _metrics!.totalRoutines.toString(),
                            icon: Icons.auto_awesome,
                            color: Constants.kSageGreen,
                          ),
                          _KpiData(
                            label: 'Usuarios con Test',
                            value: _metrics!.usersCompletedTest.toString(),
                            icon: Icons.quiz_outlined,
                            color: Constants.accent(context),
                          ),
                          _KpiData(
                            label: 'Registros de sueño',
                            value: _metrics!.totalSleepLogs.toString(),
                            icon: Icons.bedtime_outlined,
                            color: Constants.accent(context),
                          ),
                          _KpiData(
                            label: 'Comentarios',
                            value: _metrics!.totalComments.toString(),
                            icon: Icons.forum_outlined,
                            color: Constants.kSoftAmber,
                          ),
                        ],
                      ),
                      const Gap(20),

                      const _SectionTitle(title: 'Catálogo y Contenido'),
                      const Gap(10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Constants.surface(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Constants.border(context)),
                        ),
                        child: Column(
                          children: [
                            _StatRow(
                              icon: Icons.inventory_2_outlined,
                              iconColor: Constants.kSageGreen,
                              label: 'Productos del Kit activos',
                              value: '${_metrics!.activeKitProducts} / ${_metrics!.totalKitProducts}',
                            ),
                            Divider(height: 20, color: Constants.border(context)),
                            _StatRow(
                              icon: Icons.warning_amber_rounded,
                              iconColor: _metrics!.lowStockProducts > 0
                                  ? Constants.kSoftRose
                                  : Constants.kSageGreen,
                              label: 'Productos con stock bajo (≤ 3)',
                              value: _metrics!.lowStockProducts.toString(),
                              valueColor: _metrics!.lowStockProducts > 0
                                  ? Constants.kSoftRose
                                  : Constants.kSageGreen,
                            ),
                            Divider(height: 20, color: Constants.border(context)),
                            _StatRow(
                              icon: Icons.layers_outlined,
                              iconColor: Constants.accent(context),
                              label: 'Elementos CMS activos',
                              value: _metrics!.activeContentItems.toString(),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),

                      if (_metrics!.testBreakdown.isNotEmpty) ...[
                        const _SectionTitle(
                          title: 'Resultados del Test (Agregado)',
                          trailing: 'Anónimo',
                        ),
                        const Gap(10),
                        ...List.generate(_metrics!.testBreakdown.length, (qIdx) {
                          final qStat = _metrics!.testBreakdown[qIdx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Constants.surface(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Constants.border(context)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        '${qIdx + 1}. ${qStat.question}',
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.textPrimary(context),
                                        height: 1.35,
                                      ),
                                    ),
                                    const Gap(8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Constants.surfaceLight(context),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: MyText(
                                        '${qStat.totalResponses} resp.',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.textSecondary(context),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                ...qStat.options.map((opt) {
                                  final ratio = (opt.percentage / 100.0).clamp(0.0, 1.0);
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MyText(
                                                opt.answer,
                                                fontSize: 12,
                                                color: Constants.textSecondary(context),
                                              ),
                                            ),
                                            const Gap(8),
                                            MyText(
                                              '${opt.percentage}% (${opt.count})',
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w600,
                                              color: Constants.textPrimary(context),
                                            ),
                                          ],
                                        ),
                                        const Gap(5),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: ratio,
                                            minHeight: 6,
                                            backgroundColor: Constants.surfaceLight(context),
                                            valueColor: const AlwaysStoppedAnimation<Color>(
                                              Constants.kSageGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }),
                        const Gap(8),
                      ],

                      if (_metrics!.recentUsers.isNotEmpty) ...[
                        const _SectionTitle(title: 'Registros recientes'),
                        const Gap(10),
                        Container(
                          decoration: BoxDecoration(
                            color: Constants.surface(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Constants.border(context)),
                          ),
                          child: Column(
                            children: List.generate(_metrics!.recentUsers.length, (i) {
                              final u = _metrics!.recentUsers[i];
                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 4,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Constants.surfaceLight(context),
                                      child: MyText(
                                        u.initials,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.textPrimary(context),
                                      ),
                                    ),
                                    title: MyText(
                                      u.fullName,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: Constants.textPrimary(context),
                                    ),
                                    subtitle: MyText(
                                      u.email,
                                      fontSize: 11.5,
                                      color: Constants.textSecondary(context),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (u.isAdmin
                                                ? Constants.kSoftAmber
                                                : (u.isEmailVerified
                                                    ? Constants.kSageGreen
                                                    : Constants.textSecondary(context)))
                                            .withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: MyText(
                                        u.isAdmin
                                            ? 'Admin'
                                            : (u.isEmailVerified ? 'Verificado' : 'Pendiente'),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: u.isAdmin
                                            ? Constants.kSoftAmber
                                            : (u.isEmailVerified
                                                ? Constants.kSageGreen
                                                : Constants.textSecondary(context)),
                                      ),
                                    ),
                                  ),
                                  if (i < _metrics!.recentUsers.length - 1)
                                    Divider(height: 1, indent: 64, color: Constants.border(context)),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                      const Gap(24),
                    ],
                  ),
                ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;

  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            title,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: Constants.textPrimary(context),
          ),
          if (trailing != null)
            MyText(
              trailing!,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Constants.kSageGreen,
            ),
        ],
      ),
    );
  }
}

class _KpiData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _KpiGrid extends StatelessWidget {
  final List<_KpiData> items;

  const _KpiGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Constants.surface(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Constants.border(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(item.icon, color: item.color, size: 18),
                  ),
                  MyText(
                    item.value,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Constants.textPrimary(context),
                  ),
                ],
              ),
              MyText(
                item.label,
                fontSize: 12,
                color: Constants.textSecondary(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 19),
        const Gap(10),
        Expanded(
          child: MyText(
            label,
            fontSize: 13,
            color: Constants.textPrimary(context),
          ),
        ),
        MyText(
          value,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: valueColor ?? Constants.textPrimary(context),
        ),
      ],
    );
  }
}
