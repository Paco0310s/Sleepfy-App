import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sleepfy/controllers/content_controller.dart';
import 'package:sleepfy/models/content_item_model.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/views/admin/admin_content_config.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class AdminContentFormView extends StatefulWidget {
  final AdminSectionConfig config;
  final ContentItemModel? item;

  const AdminContentFormView({
    super.key,
    required this.config,
    this.item,
  });

  @override
  State<AdminContentFormView> createState() => _AdminContentFormViewState();
}

class _AdminContentFormViewState extends State<AdminContentFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _subtitleCtrl;
  late final TextEditingController _bodyCtrl;
  late final TextEditingController _urlCtrl;
  late final TextEditingController _imageUrlCtrl;
  late final TextEditingController _sortOrderCtrl;

  String _iconKey = 'help';
  bool _isActive = true;
  bool _isSaving = false;

  Uint8List? _pickedImageBytes;
  String? _pickedImageName;
  bool _removeExistingImage = false;

  bool get _isEditing => widget.item != null;

  static const _iconOptions = [
    {'key': 'help', 'label': 'Pregunta / Definición'},
    {'key': 'warning', 'label': 'Advertencia / Características'},
    {'key': 'healing', 'label': 'Salud / Efectos'},
    {'key': 'spa', 'label': 'Bienestar / Importancia'},
    {'key': 'info', 'label': 'Información general'},
  ];

  @override
  void initState() {
    super.initState();
    final it = widget.item;
    _titleCtrl = TextEditingController(text: it?.title ?? '');
    _subtitleCtrl = TextEditingController(text: it?.subtitle ?? '');
    _bodyCtrl = TextEditingController(text: it?.body ?? '');
    _urlCtrl = TextEditingController(text: it?.url ?? '');
    _imageUrlCtrl = TextEditingController(text: it?.imageUrl ?? '');
    _sortOrderCtrl = TextEditingController(text: (it?.sortOrder ?? 0).toString());
    _iconKey = it?.iconKey ?? 'help';
    _isActive = it?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _bodyCtrl.dispose();
    _urlCtrl.dispose();
    _imageUrlCtrl.dispose();
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
        _pickedImageName = file.name.isNotEmpty ? file.name : 'cover.jpg';
        _removeExistingImage = false;
      });
    } catch (_) {
      MySnackBar.showSnackBarError('No se pudo seleccionar la imagen');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      MySnackBar.showSnackBarError('Revisa los campos obligatorios');
      return;
    }

    setState(() => _isSaving = true);
    final c = widget.config;

    final payload = <String, dynamic>{
      'section': c.section,
      'title': _titleCtrl.text.trim(),
      'sortOrder': int.tryParse(_sortOrderCtrl.text.trim()) ?? 0,
      'isActive': _isActive,
    };

    if (c.subtitleLabel != null) {
      payload['subtitle'] = _subtitleCtrl.text.trim().isEmpty ? null : _subtitleCtrl.text.trim();
    }
    if (c.bodyLabel != null) {
      payload['body'] = _bodyCtrl.text.trim().isEmpty ? null : _bodyCtrl.text.trim();
    }
    if (c.urlLabel != null) {
      payload['url'] = _urlCtrl.text.trim().isEmpty ? null : _urlCtrl.text.trim();
    }
    if (c.imageUrlLabel != null) {
      payload['imageUrl'] = _imageUrlCtrl.text.trim().isEmpty ? null : _imageUrlCtrl.text.trim();
    }
    if (c.showIconPicker) {
      payload['iconKey'] = _iconKey;
    }

    ContentItemModel? saved;
    if (_isEditing) {
      saved = await ContentController.updateItem(widget.item!.id, payload);
    } else {
      saved = await ContentController.createItem(payload);
    }

    if (saved == null) {
      if (mounted) setState(() => _isSaving = false);
      return;
    }

    bool imageFailed = false;
    if (c.allowImageUpload) {
      if (_pickedImageBytes != null) {
        final uploaded = await ContentController.uploadImage(
          saved.id,
          _pickedImageBytes!,
          _pickedImageName ?? 'cover.jpg',
        );
        imageFailed = uploaded == null;
      } else if (_removeExistingImage && widget.item?.hasImage == true) {
        final removed = await ContentController.deleteImage(saved.id);
        imageFailed = removed == null;
      }
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (!imageFailed) {
      MySnackBar.showSnackBarSuccess(
        _isEditing ? 'Cambios guardados' : 'Contenido creado correctamente',
      );
    }
    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    final existingImageUrl = (!_removeExistingImage) ? widget.item?.resolvedImageUrl : null;

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: MyTitleAppBar(
          title: _isEditing ? 'Editar ${c.singularLabel}' : 'Nuevo: ${c.singularLabel}',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          children: [
            if (c.allowImageUpload) ...[
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
                      'Imagen de portada (desde galería)',
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
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      )
                    else if (existingImageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          existingImageUrl,
                          width: double.infinity,
                          height: 160,
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
                                  : 'Elegir de galería',
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
              const Gap(14),
            ],
            _buildField(
              context,
              controller: _titleCtrl,
              label: c.titleLabel,
              hint: c.titleHint,
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? 'Mínimo 2 caracteres' : null,
            ),
            if (c.subtitleLabel != null) ...[
              const Gap(12),
              _buildField(
                context,
                controller: _subtitleCtrl,
                label: c.subtitleLabel!,
                hint: c.subtitleHint ?? '',
                maxLines: 3,
                validator: c.subtitleRequired
                    ? (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null
                    : null,
              ),
            ],
            if (c.bodyLabel != null) ...[
              const Gap(12),
              _buildField(
                context,
                controller: _bodyCtrl,
                label: c.bodyLabel!,
                hint: c.bodyHint ?? '',
                maxLines: 5,
                validator: c.bodyRequired
                    ? (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null
                    : null,
              ),
            ],
            if (c.urlLabel != null) ...[
              const Gap(12),
              _buildField(
                context,
                controller: _urlCtrl,
                label: c.urlLabel!,
                hint: c.urlHint ?? 'https://...',
                keyboardType: TextInputType.url,
                validator: c.urlRequired
                    ? (v) => (v == null || v.trim().isEmpty) ? 'Enlace obligatorio' : null
                    : null,
              ),
            ],
            if (c.imageUrlLabel != null) ...[
              const Gap(12),
              _buildField(
                context,
                controller: _imageUrlCtrl,
                label: c.imageUrlLabel!,
                hint: c.imageUrlHint ?? 'https://...',
                keyboardType: TextInputType.url,
              ),
            ],
            if (c.showIconPicker) ...[
              const Gap(12),
              DropdownButtonFormField<String>(
                initialValue: _iconOptions.any((o) => o['key'] == _iconKey) ? _iconKey : 'help',
                dropdownColor: Constants.surface(context),
                style: TextStyle(color: Constants.textPrimary(context), fontSize: 13.5),
                decoration: InputDecoration(
                  labelText: 'Ícono de la tarjeta',
                  labelStyle: TextStyle(color: Constants.textSecondary(context), fontSize: 13),
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
                ),
                items: _iconOptions
                    .map((opt) => DropdownMenuItem<String>(
                          value: opt['key'],
                          child: Text(opt['label']!),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _iconKey = val);
                },
              ),
            ],
            const Gap(12),
            _buildField(
              context,
              controller: _sortOrderCtrl,
              label: 'Orden de aparición',
              hint: '0',
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v?.trim() ?? '');
                if (n == null || n < 0) return 'Número >= 0';
                return null;
              },
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
                  'Visible en la app',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Constants.textPrimary(context),
                ),
                subtitle: MyText(
                  'Si lo desactivas, quedará oculto para los usuarios.',
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
                  : (_isEditing ? 'Guardar cambios' : 'Crear elemento'),
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
      height: 100,
      decoration: BoxDecoration(
        color: Constants.surfaceLight(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Constants.border(context)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 28, color: Constants.textSecondary(context)),
          const Gap(6),
          MyText(
            'Sin imagen de galería',
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
