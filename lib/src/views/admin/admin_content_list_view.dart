import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/controllers/content_controller.dart';
import 'package:sleepfy/models/content_item_model.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/views/admin/admin_content_config.dart';
import 'package:sleepfy/src/views/admin/admin_content_form_view.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class AdminContentListView extends StatefulWidget {
  final String title;
  final List<AdminSectionConfig> sections;

  const AdminContentListView({
    super.key,
    required this.title,
    required this.sections,
  });

  @override
  State<AdminContentListView> createState() => _AdminContentListViewState();
}

class _AdminContentListViewState extends State<AdminContentListView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final Map<String, List<ContentItemModel>> _itemsBySection = {};
  bool _isLoading = true;

  AdminSectionConfig get _activeSection {
    final index = _tabController?.index ?? 0;
    return widget.sections[index.clamp(0, widget.sections.length - 1)];
  }

  @override
  void initState() {
    super.initState();
    if (widget.sections.length > 1) {
      _tabController = TabController(length: widget.sections.length, vsync: this);
      _tabController!.addListener(() {
        if (!_tabController!.indexIsChanging && mounted) {
          setState(() {});
        }
      });
    }
    _loadAllSections();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadAllSections() async {
    setState(() => _isLoading = true);
    final results = await Future.wait(
      widget.sections.map((s) => ContentController.getAdminBySection(s.section)),
    );
    if (!mounted) return;
    setState(() {
      for (int i = 0; i < widget.sections.length; i++) {
        _itemsBySection[widget.sections[i].section] = results[i];
      }
      _isLoading = false;
    });
  }

  Future<void> _loadSection(String section) async {
    final list = await ContentController.getAdminBySection(section);
    if (!mounted) return;
    setState(() {
      _itemsBySection[section] = list;
    });
  }

  Future<void> _toggleActive(ContentItemModel item) async {
    final updated = await ContentController.updateItem(
      item.id,
      {'isActive': !item.isActive},
    );
    if (updated != null) {
      MySnackBar.showSnackBarSuccess(
        updated.isActive ? 'Elemento activado' : 'Elemento ocultado',
      );
      _loadSection(item.section);
    }
  }

  Future<void> _confirmDelete(ContentItemModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Constants.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Constants.border(ctx)),
        ),
        title: MyText(
          'Eliminar elemento',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Constants.textPrimary(ctx),
        ),
        content: MyText(
          '¿Seguro que deseas eliminar "${item.title}"? Esta acción no se puede deshacer.',
          fontSize: 13.5,
          color: Constants.textSecondary(ctx),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: MyText('Cancelar', color: Constants.textSecondary(ctx)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const MyText(
              'Eliminar',
              color: Constants.kSoftRose,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final ok = await ContentController.deleteItem(item.id);
      if (ok) {
        MySnackBar.showSnackBarSuccess('Elemento eliminado');
        _loadSection(item.section);
      }
    }
  }

  Future<void> _openForm(AdminSectionConfig config, [ContentItemModel? item]) async {
    final result = await Get.to<bool>(
      () => AdminContentFormView(config: config, item: item),
    );
    if (result == true) {
      _loadSection(config.section);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTabs = widget.sections.length > 1;

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: MyTitleAppBar(title: widget.title),
        bottom: hasTabs
            ? TabBar(
                controller: _tabController,
                indicatorColor: Constants.kSageGreen,
                labelColor: Constants.textPrimary(context),
                unselectedLabelColor: Constants.textSecondary(context),
                tabs: widget.sections
                    .map((s) => Tab(text: s.tabLabel))
                    .toList(),
              )
            : null,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Constants.primary(context),
        foregroundColor: Constants.primaryContent(context),
        onPressed: () => _openForm(_activeSection),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Constants.primary(context)))
          : hasTabs
              ? TabBarView(
                  controller: _tabController,
                  children: widget.sections
                      .map((s) => _buildSectionList(s))
                      .toList(),
                )
              : _buildSectionList(widget.sections.first),
    );
  }

  Widget _buildSectionList(AdminSectionConfig config) {
    final items = _itemsBySection[config.section] ?? [];

    if (items.isEmpty) {
      return RefreshIndicator(
        color: Constants.kSageGreen,
        onRefresh: () => _loadSection(config.section),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              child: Center(
                child: MyText(
                  'No hay elementos registrados en esta sección.',
                  fontSize: 14,
                  color: Constants.textSecondary(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Constants.kSageGreen,
      onRefresh: () => _loadSection(config.section),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 88),
        itemCount: items.length,
        itemBuilder: (context, index) => _buildItemCard(context, config, items[index]),
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    AdminSectionConfig config,
    ContentItemModel item,
  ) {
    final preview = (item.subtitle?.trim().isNotEmpty ?? false)
        ? item.subtitle!.trim()
        : (item.body?.trim().isNotEmpty ?? false)
            ? item.body!.trim()
            : (item.url?.trim() ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Constants.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Constants.border(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: config.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(config.icon, color: config.accentColor, size: 21),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        item.title,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                      if (preview.isNotEmpty) ...[
                        const Gap(4),
                        MyText(
                          preview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          color: Constants.textSecondary(context),
                        ),
                      ],
                      const Gap(8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _StatusBadge(
                            label: item.isActive ? 'Activo' : 'Oculto',
                            color: item.isActive
                                ? Constants.kSageGreen
                                : Constants.textSecondary(context),
                          ),
                          _StatusBadge(
                            label: 'Orden: ${item.sortOrder}',
                            color: Constants.textSecondary(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(10),
            Divider(height: 1, color: Constants.border(context)),
            const Gap(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _toggleActive(item),
                  icon: Icon(
                    item.isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 17,
                    color: Constants.textSecondary(context),
                  ),
                  label: MyText(
                    item.isActive ? 'Ocultar' : 'Activar',
                    fontSize: 12.5,
                    color: Constants.textSecondary(context),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _openForm(config, item),
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 17,
                    color: Constants.primary(context),
                  ),
                  label: MyText(
                    'Editar',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Constants.primary(context),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _confirmDelete(item),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 17,
                    color: Constants.kSoftRose,
                  ),
                  label: const MyText(
                    'Eliminar',
                    fontSize: 12.5,
                    color: Constants.kSoftRose,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(6),
      ),
      child: MyText(
        label,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
