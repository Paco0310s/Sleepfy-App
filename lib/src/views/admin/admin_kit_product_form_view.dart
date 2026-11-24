import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sleepfy/controllers/kit_product_controller.dart';
import 'package:sleepfy/models/kit_product_model.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class AdminKitProductFormView extends StatefulWidget {
  final KitProductModel? product;

  const AdminKitProductFormView({super.key, this.product});

  @override
  State<AdminKitProductFormView> createState() => _AdminKitProductFormViewState();
}

class _AdminKitProductFormViewState extends State<AdminKitProductFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _benefitsCtrl;
  late final TextEditingController _usageCtrl;
  late final TextEditingController _warningCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _sortOrderCtrl;

  bool _isActive = true;
  bool _isSaving = false;

  Uint8List? _pickedImageBytes;
  String? _pickedImageName;
  bool _removeExistingImage = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _descriptionCtrl = TextEditingController(text: p?.description ?? '');
    _benefitsCtrl = TextEditingController(text: p?.benefits ?? '');
    _usageCtrl = TextEditingController(text: p?.usage ?? '');
    _warningCtrl = TextEditingController(text: p?.warning ?? '');
    _stockCtrl = TextEditingController(text: (p?.stock ?? 10).toString());
    _sortOrderCtrl = TextEditingController(text: (p?.sortOrder ?? 0).toString());
    _isActive = p?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _benefitsCtrl.dispose();
    _usageCtrl.dispose();
    _warningCtrl.dispose();
    _stockCtrl.dispose();
    _sortOrderCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 75,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _pickedImageBytes = bytes;
        _pickedImageName = file.name.isNotEmpty ? file.name : 'product.jpg';
        _removeExistingImage = false;
      });
    } catch (e) {
      MySnackBar.showSnackBarError('No se pudo seleccionar la imagen');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      MySnackBar.showSnackBarError('Revisa los campos obligatorios');
      return;
    }

    setState(() => _isSaving = true);

    final payload = {
      'title': _titleCtrl.text.trim(),
      'description': _descriptionCtrl.text.trim(),
      'benefits': _benefitsCtrl.text.trim(),
      'usage': _usageCtrl.text.trim(),
      'warning': _warningCtrl.text.trim().isEmpty ? null : _warningCtrl.text.trim(),
      'stock': int.tryParse(_stockCtrl.text.trim()) ?? 0,
      'sortOrder': int.tryParse(_sortOrderCtrl.text.trim()) ?? 0,
      'isActive': _isActive,
    };

    KitProductModel? saved;
    if (_isEditing) {
      saved = await KitProductController.updateProduct(widget.product!.id, payload);
    } else {
      saved = await KitProductController.createProduct(payload);
    }

    if (saved == null) {
      if (mounted) setState(() => _isSaving = false);
      return;
    }

    bool imageFailed = false;
    if (_pickedImageBytes != null) {
      final uploaded = await KitProductController.uploadImage(
        saved.id,
        _pickedImageBytes!,
        _pickedImageName ?? 'product.jpg',
      );
      imageFailed = uploaded == null;
    } else if (_removeExistingImage && widget.product?.hasImage == true) {
      final removed = await KitProductController.deleteImage(saved.id);
      imageFailed = removed == null;
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (!imageFailed) {
      MySnackBar.showSnackBarSuccess(
        _isEditing ? 'Producto actualizado' : 'Producto creado correctamente',
      );
    }
    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    final existingImageUrl = (!_removeExistingImage) ? widget.product?.imageUrl : null;

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: MyTitleAppBar(title: _isEditing ? 'Editar producto' : 'Nuevo producto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          children: [
            // Imagen del producto
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Constants.border(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    'Imagen del producto (opcional)',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Constants.textPrimary(context),
                  ),
                  const Gap(10),
                  if (_pickedImageBytes != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _pickedImageBytes!,
                        width: double.infinity,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (existingImageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        existingImageUrl,
                        width: double.infinity,
                        height: 170,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _emptyImageBox(context),
                      ),
                    )
                  else
                    _emptyImageBox(context),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Constants.border(context)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                          ),
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.photo_library_outlined,
                            size: 18,
                            color: Constants.primary(context),
                          ),
                          label: MyText(
                            (_pickedImageBytes != null || existingImageUrl != null)
                                ? 'Cambiar imagen'
                                : 'Elegir imagen',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Constants.textPrimary(context),
                          ),
                        ),
                      ),
                      if (_pickedImageBytes != null || existingImageUrl != null) ...[
                        const Gap(10),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Constants.kSoftRose),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                          ),
                          onPressed: () {
                            setState(() {
                              _pickedImageBytes = null;
                              _pickedImageName = null;
                              _removeExistingImage = true;
                            });
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: Constants.kSoftRose,
                          ),
                          label: const MyText(
                            'Quitar',
                            fontSize: 13,
                            color: Constants.kSoftRose,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Gap(16),

            _buildField(
              context,
              controller: _titleCtrl,
              label: 'Nombre del producto *',
              hint: 'Ej. Spray de Magnesio',
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? 'Mínimo 2 caracteres' : null,
            ),
            const Gap(12),

            _buildField(
              context,
              controller: _descriptionCtrl,
              label: 'Descripción *',
              hint: 'Describe brevemente qué es y para qué sirve...',
              maxLines: 3,
              validator: (v) =>
                  (v == null || v.trim().length < 5) ? 'Mínimo 5 caracteres' : null,
            ),
            const Gap(12),

            _buildField(
              context,
              controller: _benefitsCtrl,
              label: 'Beneficios *',
              hint: 'Ej. ◆ Relaja los músculos y reduce el estrés nocturno.',
              maxLines: 3,
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? 'Campo requerido' : null,
            ),
            const Gap(12),

            _buildField(
              context,
              controller: _usageCtrl,
              label: 'Modo de uso *',
              hint: 'Ej. Aplicar 3-5 atomizaciones antes de dormir.',
              maxLines: 3,
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? 'Campo requerido' : null,
            ),
            const Gap(12),

            _buildField(
              context,
              controller: _warningCtrl,
              label: 'Precauciones (opcional)',
              hint: 'Ej. Solo para uso externo.',
              maxLines: 2,
            ),
            const Gap(12),

            Row(
              children: [
                Expanded(
                  child: _buildField(
                    context,
                    controller: _stockCtrl,
                    label: 'Stock',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v?.trim() ?? '');
                      if (n == null || n < 0) return 'Número >= 0';
                      return null;
                    },
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _buildField(
                    context,
                    controller: _sortOrderCtrl,
                    label: 'Orden',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v?.trim() ?? '');
                      if (n == null || n < 0) return 'Número >= 0';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const Gap(14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Constants.border(context)),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: Constants.kSageGreen,
                title: MyText(
                  'Producto visible en la app',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Constants.textPrimary(context),
                ),
                subtitle: MyText(
                  'Si lo desactivas, solo lo verán los administradores.',
                  fontSize: 11.5,
                  color: Constants.textSecondary(context),
                ),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
            ),
            const Gap(22),

            MyButton(
              text: _isSaving
                  ? 'Guardando...'
                  : (_isEditing ? 'Guardar cambios' : 'Crear producto'),
              onPressed: _isSaving ? () {} : _save,
            ),
            const Gap(28),
          ],
        ),
      ),
    );
  }

  Widget _emptyImageBox(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        color: Constants.surfaceLight(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Constants.border(context)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 30, color: Constants.textSecondary(context)),
          const Gap(6),
          MyText(
            'Sin imagen seleccionada',
            fontSize: 12,
            color: Constants.textSecondary(context),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: Constants.textPrimary(context), fontSize: 13.5),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Constants.textSecondary(context), fontSize: 13),
        hintStyle: TextStyle(
          color: Constants.textSecondary(context).withValues(alpha: 0.6),
          fontSize: 13,
        ),
        filled: true,
        fillColor: Constants.surface(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Constants.border(context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Constants.border(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Constants.kSageGreen, width: 1.5),
        ),
      ),
    );
  }
}
