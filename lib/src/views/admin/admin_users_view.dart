import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/controllers/admin_controller.dart';
import 'package:sleepfy/models/admin_models.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;
  List<AdminUserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final list = await AdminController.listUsers(search: _searchCtrl.text);
    if (!mounted) return;
    setState(() {
      _users = list;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _loadUsers);
    setState(() {});
  }

  Future<void> _confirmToggleAdmin(AdminUserModel user, bool nextValue) async {
    if (user.id == UserPreferences.id && !nextValue) {
      MySnackBar.showSnackBarError('No puedes quitarte permisos de administrador a ti mismo');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Constants.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Constants.border(ctx)),
        ),
        title: MyText(
          nextValue ? 'Dar permisos de administrador' : 'Revocar administrador',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Constants.textPrimary(ctx),
        ),
        content: MyText(
          nextValue
              ? '¿Deseas otorgar permisos de administrador a ${user.fullName} (${user.email})?'
              : '¿Deseas quitar los permisos de administrador a ${user.fullName}?',
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
            child: MyText(
              nextValue ? 'Confirmar' : 'Revocar',
              color: nextValue ? Constants.kSageGreen : Constants.kSoftRose,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final updated = await AdminController.toggleUserAdmin(user.id, nextValue);
    if (updated != null) {
      MySnackBar.showSnackBarSuccess(
        updated.isAdmin
            ? '${updated.name} ahora es administrador'
            : 'Permisos revocados a ${updated.name}',
      );
      _loadUsers();
    }
  }

  void _openUserActionsSheet(AdminUserModel user) {
    final isSelf = user.id == UserPreferences.id;

    showModalBottomSheet(
      context: context,
      backgroundColor: Constants.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Constants.border(sheetCtx),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Constants.surfaceLight(sheetCtx),
                      child: MyText(
                        user.initials,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(sheetCtx),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            user.fullName,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Constants.textPrimary(sheetCtx),
                          ),
                          MyText(
                            user.email,
                            fontSize: 12,
                            color: Constants.textSecondary(sheetCtx),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Divider(height: 1, color: Constants.border(sheetCtx)),
              ListTile(
                leading: Icon(Icons.edit_outlined, color: Constants.primary(sheetCtx)),
                title: MyText(
                  'Editar datos del usuario',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Constants.textPrimary(sheetCtx),
                ),
                subtitle: MyText(
                  'Corregir nombre, apellido o correo electrónico',
                  fontSize: 12,
                  color: Constants.textSecondary(sheetCtx),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _openEditUserDialog(user);
                },
              ),
              ListTile(
                leading: const Icon(Icons.pin_outlined, color: Constants.kSageGreen),
                title: MyText(
                  'Código de verificación / Correo',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Constants.textPrimary(sheetCtx),
                ),
                subtitle: MyText(
                  user.isEmailVerified
                      ? 'Correo verificado • Ver o generar código'
                      : 'Pendiente de verificar • Obtener código o aprobar',
                  fontSize: 12,
                  color: Constants.textSecondary(sheetCtx),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _openVerificationCodeDialog(user);
                },
              ),
              ListTile(
                leading: Icon(Icons.lock_reset_rounded, color: Constants.accent(sheetCtx)),
                title: MyText(
                  'Cambiar contraseña',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Constants.textPrimary(sheetCtx),
                ),
                subtitle: MyText(
                  'Asigna una contraseña nueva y cierra sus sesiones',
                  fontSize: 12,
                  color: Constants.textSecondary(sheetCtx),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _openChangePasswordDialog(user);
                },
              ),
              ListTile(
                leading: const Icon(Icons.devices_other_rounded, color: Constants.kSoftAmber),
                title: MyText(
                  'Cerrar sesiones activas (${user.activeSessions})',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Constants.textPrimary(sheetCtx),
                ),
                subtitle: MyText(
                  'Desconecta todos los dispositivos de esta cuenta',
                  fontSize: 12,
                  color: Constants.textSecondary(sheetCtx),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _confirmClearSessions(user);
                },
              ),
              if (!isSelf)
                ListTile(
                  leading: const Icon(Icons.delete_forever_outlined, color: Constants.kSoftRose),
                  title: const MyText(
                    'Eliminar cuenta',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Constants.kSoftRose,
                  ),
                  subtitle: MyText(
                    'Borra permanentemente la cuenta y sus datos',
                    fontSize: 12,
                    color: Constants.textSecondary(sheetCtx),
                  ),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    _confirmDeleteUser(user);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openEditUserDialog(AdminUserModel user) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: user.name);
    final lastNameCtrl = TextEditingController(text: user.lastName);
    final emailCtrl = TextEditingController(text: user.email);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Constants.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Constants.border(ctx)),
        ),
        title: const MyTitleAppBar(title: 'Editar usuario'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  style: TextStyle(color: Constants.textPrimary(ctx), fontSize: 13.5),
                  validator: (v) =>
                      (v == null || v.trim().length < 2) ? 'Mínimo 2 caracteres' : null,
                  decoration: InputDecoration(
                    labelText: 'Nombre *',
                    labelStyle: TextStyle(color: Constants.textSecondary(ctx), fontSize: 13),
                    filled: true,
                    fillColor: Constants.surfaceLight(ctx),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Constants.border(ctx)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Constants.border(ctx)),
                    ),
                  ),
                ),
                const Gap(10),
                TextFormField(
                  controller: lastNameCtrl,
                  style: TextStyle(color: Constants.textPrimary(ctx), fontSize: 13.5),
                  validator: (v) =>
                      (v == null || v.trim().length < 2) ? 'Mínimo 2 caracteres' : null,
                  decoration: InputDecoration(
                    labelText: 'Apellido *',
                    labelStyle: TextStyle(color: Constants.textSecondary(ctx), fontSize: 13),
                    filled: true,
                    fillColor: Constants.surfaceLight(ctx),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Constants.border(ctx)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Constants.border(ctx)),
                    ),
                  ),
                ),
                const Gap(10),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Constants.textPrimary(ctx), fontSize: 13.5),
                  validator: (v) {
                    final val = v?.trim() ?? '';
                    if (val.isEmpty || !val.contains('@') || !val.contains('.')) {
                      return 'Ingresa un correo válido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico *',
                    labelStyle: TextStyle(color: Constants.textSecondary(ctx), fontSize: 13),
                    filled: true,
                    fillColor: Constants.surfaceLight(ctx),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Constants.border(ctx)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Constants.border(ctx)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: MyText('Cancelar', color: Constants.textSecondary(ctx)),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: const MyText(
              'Guardar',
              color: Constants.kSageGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final updated = await AdminController.updateUser(
        user.id,
        name: nameCtrl.text,
        lastName: lastNameCtrl.text,
        email: emailCtrl.text,
      );
      if (updated != null) {
        MySnackBar.showSnackBarSuccess('Datos del usuario actualizados');
        _loadUsers();
      }
    }

    nameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
  }

  Future<void> _openVerificationCodeDialog(AdminUserModel user) async {
    final initial = await AdminController.getUserVerificationCode(user.id);
    if (!mounted || initial == null) return;

    var current = initial;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) {
          final code = current.verificationCode;
          return AlertDialog(
            backgroundColor: Constants.surface(dialogCtx),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Constants.border(dialogCtx)),
            ),
            title: const MyTitleAppBar(title: 'Verificación de correo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  current.email,
                  fontSize: 12.5,
                  color: Constants.textSecondary(dialogCtx),
                ),
                const Gap(12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Constants.surfaceLight(dialogCtx),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Constants.border(dialogCtx)),
                  ),
                  child: Column(
                    children: [
                      MyText(
                        code != null && code.isNotEmpty ? code : 'Sin código activo',
                        fontSize: code != null && code.isNotEmpty ? 24 : 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: code != null && code.isNotEmpty ? 4 : 0,
                        color: code != null && code.isNotEmpty
                            ? Constants.kSageGreen
                            : Constants.textSecondary(dialogCtx),
                      ),
                      if (code != null && code.isNotEmpty) ...[
                        const Gap(8),
                        TextButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: code));
                            MySnackBar.showSnackBarSuccess('Código copiado al portapapeles');
                          },
                          icon: const Icon(Icons.copy_rounded, size: 15, color: Constants.kSageGreen),
                          label: const MyText(
                            'Copiar código',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Constants.kSageGreen,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Gap(12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Constants.border(dialogCtx)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      final regenerated = await AdminController.generateUserVerificationCode(user.id);
                      if (regenerated != null) {
                        setDialogState(() => current = regenerated);
                        MySnackBar.showSnackBarSuccess('Nuevo código generado (30 min)');
                      }
                    },
                    icon: Icon(Icons.refresh_rounded, size: 17, color: Constants.primary(dialogCtx)),
                    label: MyText(
                      'Generar nuevo código',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Constants.textPrimary(dialogCtx),
                    ),
                  ),
                ),
                if (!current.isEmailVerified) ...[
                  const Gap(8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Constants.kSageGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        final ok = await AdminController.verifyUserEmail(user.id);
                        if (ok && dialogCtx.mounted) {
                          Navigator.pop(dialogCtx);
                          MySnackBar.showSnackBarSuccess('Correo marcado como verificado');
                          _loadUsers();
                        }
                      },
                      icon: const Icon(Icons.verified_outlined, size: 17, color: Constants.kSageGreen),
                      label: const MyText(
                        'Marcar correo verificado',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Constants.kSageGreen,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: MyText('Cerrar', color: Constants.textSecondary(dialogCtx)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openChangePasswordDialog(AdminUserModel user) async {
    final formKey = GlobalKey<FormState>();
    final passCtrl = TextEditingController();
    bool obscure = true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          backgroundColor: Constants.surface(dialogCtx),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Constants.border(dialogCtx)),
          ),
          title: const MyTitleAppBar(title: 'Cambiar contraseña'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  'Usuario: ${user.fullName}',
                  fontSize: 12.5,
                  color: Constants.textSecondary(dialogCtx),
                ),
                const Gap(12),
                TextFormField(
                  controller: passCtrl,
                  obscureText: obscure,
                  style: TextStyle(color: Constants.textPrimary(dialogCtx), fontSize: 13.5),
                  validator: (v) {
                    if (v == null || v.length < 8) return 'Mínimo 8 caracteres';
                    if (v.length > 64) return 'Máximo 64 caracteres';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Nueva contraseña *',
                    labelStyle: TextStyle(color: Constants.textSecondary(dialogCtx), fontSize: 13),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 19,
                        color: Constants.textSecondary(dialogCtx),
                      ),
                      onPressed: () => setDialogState(() => obscure = !obscure),
                    ),
                    filled: true,
                    fillColor: Constants.surfaceLight(dialogCtx),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Constants.border(dialogCtx)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Constants.border(dialogCtx)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(false),
              child: MyText('Cancelar', color: Constants.textSecondary(dialogCtx)),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  Navigator.of(dialogCtx).pop(true);
                }
              },
              child: const MyText(
                'Actualizar',
                color: Constants.kSageGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final ok = await AdminController.changeUserPassword(user.id, passCtrl.text);
      if (ok) {
        MySnackBar.showSnackBarSuccess('Contraseña actualizada y sesiones cerradas');
        _loadUsers();
      }
    }

    passCtrl.dispose();
  }

  Future<void> _confirmClearSessions(AdminUserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Constants.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Constants.border(ctx)),
        ),
        title: const MyTitleAppBar(title: 'Cerrar sesiones activas'),
        content: MyText(
          'Se cerrarán ${user.activeSessions} sesión(es) activas de ${user.fullName}. Tendrá que volver a iniciar sesión en sus dispositivos.',
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
              'Cerrar sesiones',
              color: Constants.kSoftAmber,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final ok = await AdminController.clearUserSessions(user.id);
    if (ok) {
      MySnackBar.showSnackBarSuccess('Sesiones cerradas correctamente');
      _loadUsers();
    }
  }

  Future<void> _confirmDeleteUser(AdminUserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Constants.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Constants.border(ctx)),
        ),
        title: const MyTitleAppBar(title: 'Eliminar cuenta'),
        content: MyText(
          '¿Seguro que deseas eliminar la cuenta de ${user.fullName} (${user.email}) y todos sus datos? Esta acción no se puede deshacer.',
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

    if (confirmed != true) return;
    final ok = await AdminController.deleteUser(user.id);
    if (ok) {
      MySnackBar.showSnackBarSuccess('Cuenta eliminada correctamente');
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Gestión de Usuarios'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              style: TextStyle(color: Constants.textPrimary(context), fontSize: 13.5),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o correo...',
                hintStyle: TextStyle(
                  color: Constants.textSecondary(context).withValues(alpha: 0.7),
                  fontSize: 13,
                ),
                prefixIcon: Icon(Icons.search_rounded, color: Constants.textSecondary(context)),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close_rounded, color: Constants.textSecondary(context)),
                        onPressed: () {
                          _searchCtrl.clear();
                          _loadUsers();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Constants.surface(context),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  borderSide: const BorderSide(color: Constants.kSageGreen, width: 1.4),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Constants.primary(context)))
                : _users.isEmpty
                    ? RefreshIndicator(
                        color: Constants.kSageGreen,
                        onRefresh: _loadUsers,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
                              child: Center(
                                child: MyText(
                                  'No se encontraron usuarios con ese criterio.',
                                  fontSize: 13.5,
                                  color: Constants.textSecondary(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: Constants.kSageGreen,
                        onRefresh: _loadUsers,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                          itemCount: _users.length,
                          itemBuilder: (context, index) => _buildUserCard(context, _users[index]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, AdminUserModel user) {
    final isSelf = user.id == UserPreferences.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Constants.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: user.isAdmin
              ? Constants.kSageGreen.withValues(alpha: 0.45)
              : Constants.border(context),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openUserActionsSheet(user),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: user.isAdmin
                    ? Constants.kSageGreen.withValues(alpha: 0.16)
                    : Constants.surfaceLight(context),
                child: MyText(
                  user.initials,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: user.isAdmin ? Constants.kSageGreen : Constants.textPrimary(context),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: MyText(
                            user.fullName,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Constants.textPrimary(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelf) ...[
                          const Gap(6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Constants.accent(context).withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: MyText(
                              'Tú',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Constants.accent(context),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Gap(2),
                    MyText(
                      user.email,
                      fontSize: 12,
                      color: Constants.textSecondary(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(5),
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user.isEmailVerified
                                  ? Icons.verified_outlined
                                  : Icons.hourglass_bottom_rounded,
                              size: 13,
                              color: user.isEmailVerified
                                  ? Constants.kSageGreen
                                  : Constants.kSoftAmber,
                            ),
                            const Gap(4),
                            MyText(
                              user.isEmailVerified ? 'Verificado' : 'Sin verificar',
                              fontSize: 11,
                              color: user.isEmailVerified
                                  ? Constants.kSageGreen
                                  : Constants.kSoftAmber,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.devices_rounded,
                              size: 13,
                              color: Constants.textSecondary(context),
                            ),
                            const Gap(4),
                            MyText(
                              '${user.activeSessions} sesión(es)',
                              fontSize: 11,
                              color: Constants.textSecondary(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(6),
              Column(
                children: [
                  Switch.adaptive(
                    value: user.isAdmin,
                    activeTrackColor: Constants.kSageGreen,
                    onChanged: isSelf
                        ? null
                        : (val) => _confirmToggleAdmin(user, val),
                  ),
                  MyText(
                    user.isAdmin ? 'Admin' : 'Usuario',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: user.isAdmin
                        ? Constants.kSageGreen
                        : Constants.textSecondary(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
