import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/controllers/kit_product_controller.dart';
import 'package:sleepfy/models/kit_product_model.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/views/admin/admin_kit_product_form_view.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class AdminKitProductsView extends StatefulWidget {
  const AdminKitProductsView({super.key});

  @override
  State<AdminKitProductsView> createState() => _AdminKitProductsViewState();
}

class _AdminKitProductsViewState extends State<AdminKitProductsView> {
  List<KitProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final list = await KitProductController.getAdminProducts();
    if (!mounted) return;
    setState(() {
      _products = list;
      _isLoading = false;
    });
  }

  Future<void> _toggleActive(KitProductModel product) async {
    final updated = await KitProductController.updateProduct(
      product.id,
      {'isActive': !product.isActive},
    );
    if (updated != null) {
      MySnackBar.showSnackBarSuccess(
        updated.isActive ? 'Producto activado' : 'Producto ocultado',
      );
      _loadProducts();
    }
  }

  Future<void> _confirmDelete(KitProductModel product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Constants.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Constants.border(ctx)),
        ),
        title: MyText(
          'Eliminar producto',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Constants.textPrimary(ctx),
        ),
        content: MyText(
          '¿Seguro que deseas eliminar "${product.title}"? Esta acción no se puede deshacer.',
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
      final ok = await KitProductController.deleteProduct(product.id);
      if (ok) {
        MySnackBar.showSnackBarSuccess('Producto eliminado');
        _loadProducts();
      }
    }
  }

  Future<void> _openForm([KitProductModel? product]) async {
    final result = await Get.to<bool>(() => AdminKitProductFormView(product: product));
    if (result == true) {
      _loadProducts();
    }
  }

  Future<void> _editContactSettings() async {
    final current = await KitProductController.getSettings();
    if (!mounted) return;

    final igCtrl = TextEditingController(text: current.instagramUrl);
    final wa1Ctrl = TextEditingController(text: current.whatsapp1);
    final wa2Ctrl = TextEditingController(text: current.whatsapp2);

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Constants.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Constants.border(ctx)),
        ),
        title: MyText(
          'Enlaces de compra del Kit',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Constants.textPrimary(ctx),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(ctx, igCtrl, 'Instagram URL', 'https://www.instagram.com/_sleepfy/'),
              const Gap(10),
              _dialogField(ctx, wa1Ctrl, 'WhatsApp 1 (10 dígitos)', '3921694141', isPhone: true),
              const Gap(10),
              _dialogField(ctx, wa2Ctrl, 'WhatsApp 2 (opcional)', '3929308377', isPhone: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: MyText('Cancelar', color: Constants.textSecondary(ctx)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const MyText(
              'Guardar',
              color: Constants.kSageGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (saved == true) {
      final res = await KitProductController.updateSettings({
        'instagramUrl': igCtrl.text.trim(),
        'whatsapp1': wa1Ctrl.text.trim(),
        'whatsapp2': wa2Ctrl.text.trim(),
      });
      if (res != null) {
        MySnackBar.showSnackBarSuccess('Enlaces de contacto actualizados');
      }
    }

    igCtrl.dispose();
    wa1Ctrl.dispose();
    wa2Ctrl.dispose();
  }

  Widget _dialogField(
    BuildContext context,
    TextEditingController controller,
    String label,
    String hint, {
    bool isPhone = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.url,
      style: TextStyle(color: Constants.textPrimary(context), fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Constants.textSecondary(context), fontSize: 12),
        filled: true,
        fillColor: Constants.surfaceLight(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Constants.border(context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Constants.border(context)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Productos del Kit'),
        actions: [
          IconButton(
            icon: Icon(Icons.contact_phone_outlined, color: Constants.textPrimary(context), size: 21),
            tooltip: 'Enlaces de compra',
            onPressed: _editContactSettings,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Constants.primary(context),
        foregroundColor: Constants.primaryContent(context),
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Constants.primary(context)))
          : _products.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: MyText(
                      'No hay productos registrados todavía.',
                      fontSize: 14,
                      color: Constants.textSecondary(context),
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: Constants.kSageGreen,
                  onRefresh: _loadProducts,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 88),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final p = _products[index];
                      return _buildAdminProductCard(context, p);
                    },
                  ),
                ),
    );
  }

  Widget _buildAdminProductCard(BuildContext context, KitProductModel product) {
    final imageUrl = product.imageUrl;

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
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderThumb(context),
                    ),
                  )
                else
                  _placeholderThumb(context),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        product.title,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                      const Gap(4),
                      MyText(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12,
                        color: Constants.textSecondary(context),
                      ),
                      const Gap(8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _Badge(
                            label: product.isActive ? 'Activo' : 'Oculto',
                            color: product.isActive ? Constants.kSageGreen : Constants.textSecondary(context),
                          ),
                          _Badge(
                            label: 'Stock: ${product.stock}',
                            color: product.stock > 0 ? Constants.accent(context) : Constants.kSoftRose,
                          ),
                          _Badge(
                            label: 'Orden: ${product.sortOrder}',
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
                  onPressed: () => _toggleActive(product),
                  icon: Icon(
                    product.isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 17,
                    color: Constants.textSecondary(context),
                  ),
                  label: MyText(
                    product.isActive ? 'Ocultar' : 'Activar',
                    fontSize: 12.5,
                    color: Constants.textSecondary(context),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _openForm(product),
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
                  onPressed: () => _confirmDelete(product),
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

  Widget _placeholderThumb(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Constants.surfaceLight(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.spa_outlined, color: Constants.kSageGreen, size: 22),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

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
