import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/controllers/user_controller.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/login_view.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class InformationSesionView extends StatefulWidget {
  const InformationSesionView({super.key});

  @override
  State<InformationSesionView> createState() => _InformationSesionViewState();
}

class _InformationSesionViewState extends State<InformationSesionView> {
  Future<void> _showEditProfileDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: UserPreferences.name ?? '');
    final lastNameCtrl = TextEditingController(text: UserPreferences.lastName ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Constants.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Constants.border(ctx)),
        ),
        title: const MyTitleAppBar(title: 'Editar perfil'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                style: TextStyle(color: Constants.textPrimary(ctx), fontSize: 13.5),
                validator: (v) =>
                    (v == null || v.trim().length < 2) ? 'Mínimo 2 caracteres' : null,
                decoration: InputDecoration(
                  labelText: 'Nombre',
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
              const Gap(12),
              TextFormField(
                controller: lastNameCtrl,
                style: TextStyle(color: Constants.textPrimary(ctx), fontSize: 13.5),
                validator: (v) =>
                    (v == null || v.trim().length < 2) ? 'Mínimo 2 caracteres' : null,
                decoration: InputDecoration(
                  labelText: 'Apellido',
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

    if (saved == true) {
      final ok = await UserController.updateProfile(
        name: nameCtrl.text,
        lastName: lastNameCtrl.text,
      );
      if (ok && mounted) {
        setState(() {});
        MySnackBar.showSnackBarSuccess('Perfil actualizado correctamente');
      }
    }

    nameCtrl.dispose();
    lastNameCtrl.dispose();
  }

  Future<void> _performLocalLogout() async {
    await UserPreferences.logout();
    if (mounted) {
      Provider.of<TestProvider>(context, listen: false).reset();
      Provider.of<ControlDreamsProvider>(context, listen: false).reset();
    }
    Get.offAll(() => const LoginView());
  }

  Future<void> _confirmDeleteAccount() async {
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
          'Esta acción eliminará permanentemente tu cuenta y todos tus datos (rutinas personalizadas, respuestas del test, registros de sueño y comentarios).\n\n¿Seguro que deseas continuar?',
          color: Constants.textSecondary(ctx),
          fontSize: 13.5,
          height: 1.45,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: MyText('Cancelar', color: Constants.textSecondary(ctx)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const MyText(
              'Eliminar definitivamente',
              color: Constants.kSoftRose,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final deleted = await UserController.deleteAccount();
    if (deleted) {
      await _performLocalLogout();
      MySnackBar.showSnackBarSuccess('Tu cuenta ha sido eliminada');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = UserPreferences.name?.trim() ?? 'INVITADO';
    final lastName = UserPreferences.lastName?.trim() ?? '';
    final fullName = '$name $lastName'.trim();
    final email = UserPreferences.email;

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Perfil y Sesión'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(10),
              // Avatar minimalista
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.surface(context),
                  border: Border.all(color: Constants.border(context), width: 1.5),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 56,
                  color: Constants.accent(context),
                ),
              ),
              const Gap(16),
              MyText(
                fullName,
                color: Constants.textPrimary(context),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              const Gap(4),
              MyText(
                email ?? 'Sin correo electrónico',
                color: Constants.textSecondary(context),
                fontSize: 13.5,
              ),
              const Gap(28),

              // Tarjeta informativa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Constants.surface(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Constants.border(context)),
                ),
                child: Column(
                  children: [
                    _buildProfileItem(
                      context,
                      icon: Icons.person_outline_rounded,
                      label: 'Nombre completo',
                      value: fullName,
                    ),
                    Divider(height: 24, color: Constants.border(context)),
                    _buildProfileItem(
                      context,
                      icon: Icons.mail_outline_rounded,
                      label: 'Correo de acceso',
                      value: email ?? '-',
                    ),
                    Divider(height: 24, color: Constants.border(context)),
                    _buildProfileItem(
                      context,
                      icon: Icons.verified_user_outlined,
                      label: 'Estado de la cuenta',
                      value: 'Activa y verificada',
                      valueColor: Constants.kSageGreen,
                    ),
                  ],
                ),
              ),
              const Gap(16),

              // Editar perfil
              MyButton(
                outlined: true,
                text: 'Editar perfil',
                onPressed: _showEditProfileDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_outlined, color: Constants.textPrimary(context), size: 18),
                    const Gap(8),
                    MyText(
                      'Editar nombre y apellido',
                      color: Constants.textPrimary(context),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
              const Gap(12),

              // Cerrar sesión
              MyButton(
                outlined: true,
                text: 'Cerrar sesión',
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Constants.kSoftRose, size: 19),
                    Gap(8),
                    MyText(
                      'Cerrar sesión',
                      color: Constants.kSoftRose,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ],
                ),
                onPressed: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Constants.surface(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: Constants.border(context)),
                        ),
                        title: const MyTitleAppBar(title: '¿Cerrar sesión?'),
                        content: MyText(
                          'Tendrás que volver a ingresar tus credenciales para acceder a tus rutinas y estadísticas.',
                          color: Constants.textSecondary(context),
                          fontSize: 13.5,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: MyText('Cancelar', color: Constants.textSecondary(context)),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await UserController.logoutRemote();
                              await _performLocalLogout();
                            },
                            child: const MyText(
                              'Cerrar sesión',
                              color: Constants.kSoftRose,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const Gap(14),

              // Eliminar cuenta
              TextButton.icon(
                onPressed: _confirmDeleteAccount,
                icon: Icon(
                  Icons.delete_forever_outlined,
                  size: 18,
                  color: Constants.kSoftRose.withValues(alpha: 0.85),
                ),
                label: MyText(
                  'Eliminar mi cuenta',
                  fontSize: 13,
                  color: Constants.kSoftRose.withValues(alpha: 0.85),
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: Constants.textSecondary(context), size: 20),
        const Gap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                label,
                fontSize: 11.5,
                color: Constants.textSecondary(context),
              ),
              const Gap(2),
              MyText(
                value,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Constants.textPrimary(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
