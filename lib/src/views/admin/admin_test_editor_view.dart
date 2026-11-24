import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/controllers/admin_controller.dart';
import 'package:sleepfy/models/admin_models.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class AdminTestEditorView extends StatefulWidget {
  const AdminTestEditorView({super.key});

  @override
  State<AdminTestEditorView> createState() => _AdminTestEditorViewState();
}

class _AdminTestEditorViewState extends State<AdminTestEditorView> {
  AdminTestModel? _test;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async {
    final test = await AdminController.getLatestTest();
    if (!mounted) return;
    setState(() {
      _test = test;
      _isLoading = false;
    });
  }

  Future<void> _openForm([AdminQuestionModel? question]) async {
    final saved = await Get.to<bool>(
      () => AdminQuestionFormView(question: question),
    );
    if (saved == true) {
      _loadTest();
    }
  }

  Future<void> _confirmDelete(AdminQuestionModel question) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Constants.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Constants.border(ctx)),
        ),
        title: MyText(
          'Eliminar pregunta',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Constants.textPrimary(ctx),
        ),
        content: MyText(
          '¿Seguro que deseas eliminar esta pregunta y todas sus opciones de respuesta?',
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
      final ok = await AdminController.deleteQuestion(question.id);
      if (ok) {
        MySnackBar.showSnackBarSuccess('Pregunta eliminada');
        _loadTest();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = _test?.questions ?? [];

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Editor del Test de Sueño'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Constants.primary(context),
        foregroundColor: Constants.primaryContent(context),
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Pregunta', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Constants.primary(context)))
          : questions.isEmpty
              ? RefreshIndicator(
                  color: Constants.kSageGreen,
                  onRefresh: _loadTest,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                        child: Center(
                          child: MyText(
                            'No hay preguntas registradas en el test todavía.',
                            fontSize: 14,
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
                  onRefresh: _loadTest,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 88),
                    itemCount: questions.length,
                    itemBuilder: (context, index) =>
                        _buildQuestionCard(context, index, questions[index]),
                  ),
                ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    int index,
    AdminQuestionModel q,
  ) {
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
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Constants.kSageGreen.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: MyText(
                  '${index + 1}',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Constants.kSageGreen,
                ),
              ),
              const Gap(10),
              Expanded(
                child: MyText(
                  q.question,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Constants.textPrimary(context),
                  height: 1.35,
                ),
              ),
            ],
          ),
          const Gap(12),
          ...q.options.map((opt) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Constants.surfaceLight(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MyText(
                    '• ${opt.answer}',
                    fontSize: 12.5,
                    color: Constants.textSecondary(context),
                  ),
                ),
              )),
          const Gap(6),
          Divider(height: 1, color: Constants.border(context)),
          const Gap(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _openForm(q),
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
                onPressed: () => _confirmDelete(q),
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
    );
  }
}

class _OptionEntry {
  final int? id;
  final TextEditingController controller;

  _OptionEntry({this.id, required String initialText})
      : controller = TextEditingController(text: initialText);
}

class AdminQuestionFormView extends StatefulWidget {
  final AdminQuestionModel? question;

  const AdminQuestionFormView({super.key, this.question});

  @override
  State<AdminQuestionFormView> createState() => _AdminQuestionFormViewState();
}

class _AdminQuestionFormViewState extends State<AdminQuestionFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionCtrl;
  final List<_OptionEntry> _options = [];
  bool _isSaving = false;

  bool get _isEditing => widget.question != null;

  @override
  void initState() {
    super.initState();
    final q = widget.question;
    _questionCtrl = TextEditingController(text: q?.question ?? '');

    if (q != null && q.options.isNotEmpty) {
      for (final opt in q.options) {
        _options.add(_OptionEntry(id: opt.id, initialText: opt.answer));
      }
    } else {
      _options.add(_OptionEntry(initialText: ''));
      _options.add(_OptionEntry(initialText: ''));
    }
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    for (final entry in _options) {
      entry.controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _options.add(_OptionEntry(initialText: ''));
    });
  }

  void _removeOption(int index) {
    if (_options.length <= 2) {
      MySnackBar.showSnackBarError('Debe haber al menos 2 opciones de respuesta');
      return;
    }
    setState(() {
      final removed = _options.removeAt(index);
      removed.controller.dispose();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      MySnackBar.showSnackBarError('Completa la pregunta y todas las opciones');
      return;
    }

    final optionPayloads = _options
        .map((e) => <String, dynamic>{
              if (e.id != null) 'id': e.id,
              'answer': e.controller.text.trim(),
            })
        .toList();

    setState(() => _isSaving = true);

    AdminQuestionModel? result;
    if (_isEditing) {
      result = await AdminController.updateQuestion(
        widget.question!.id,
        _questionCtrl.text.trim(),
        optionPayloads,
      );
    } else {
      result = await AdminController.createQuestion(
        _questionCtrl.text.trim(),
        optionPayloads,
      );
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (result != null) {
      MySnackBar.showSnackBarSuccess(
        _isEditing ? 'Pregunta actualizada' : 'Pregunta creada correctamente',
      );
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: MyTitleAppBar(title: _isEditing ? 'Editar pregunta' : 'Nueva pregunta'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          children: [
            TextFormField(
              controller: _questionCtrl,
              maxLines: 3,
              style: TextStyle(color: Constants.textPrimary(context), fontSize: 13.5),
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? 'Mínimo 2 caracteres' : null,
              decoration: InputDecoration(
                labelText: 'Texto de la pregunta *',
                hintText: 'Ej. ¿Cuánto tiempo tardas habitualmente en conciliar el sueño?',
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Constants.kSageGreen, width: 1.5),
                ),
              ),
            ),
            const Gap(20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  'Opciones de respuesta',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Constants.textPrimary(context),
                ),
                TextButton.icon(
                  onPressed: _addOption,
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18, color: Constants.kSageGreen),
                  label: const MyText(
                    'Agregar opción',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Constants.kSageGreen,
                  ),
                ),
              ],
            ),
            const Gap(8),

            ...List.generate(_options.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _options[i].controller,
                        maxLines: 2,
                        minLines: 1,
                        style: TextStyle(color: Constants.textPrimary(context), fontSize: 13),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Opción requerida' : null,
                        decoration: InputDecoration(
                          labelText: 'Opción ${i + 1} *',
                          labelStyle: TextStyle(color: Constants.textSecondary(context), fontSize: 12.5),
                          filled: true,
                          fillColor: Constants.surface(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Constants.border(context)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Constants.border(context)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Constants.kSageGreen, width: 1.4),
                          ),
                        ),
                      ),
                    ),
                    const Gap(6),
                    IconButton(
                      tooltip: 'Quitar opción',
                      onPressed: () => _removeOption(i),
                      icon: Icon(
                        Icons.remove_circle_outline_rounded,
                        color: _options.length > 2
                            ? Constants.kSoftRose
                            : Constants.textSecondary(context).withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const Gap(20),
            MyButton(
              text: _isSaving
                  ? 'Guardando...'
                  : (_isEditing ? 'Guardar cambios' : 'Crear pregunta'),
              onPressed: _isSaving ? () {} : _save,
            ),
            const Gap(28),
          ],
        ),
      ),
    );
  }
}
