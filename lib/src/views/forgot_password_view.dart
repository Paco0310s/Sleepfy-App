import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/controllers/user_controller.dart';
import 'package:sleepfy/src/functions/validations.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:sleepfy/src/widgets/widgets.dart';

class ForgotPasswordView extends StatefulWidget {
  final String? initialEmail;

  const ForgotPasswordView({super.key, this.initialEmail});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<FormState> _step1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2Key = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _codeSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendRecoveryCode() async {
    if (!_step1Key.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final ok = await UserController.forgotPassword(email);

    if (ok && mounted) {
      setState(() {
        _codeSent = true;
      });
      MySnackBar.showSnackBarSuccess('Te enviamos un código de 6 dígitos a $email');
    }
  }

  Future<void> _resetPassword() async {
    if (_codeController.text.trim().length != 6) {
      MySnackBar.showSnackBarError('Ingresa el código de 6 dígitos enviado a tu correo');
      return;
    }
    if (!_step2Key.currentState!.validate()) return;

    final ok = await UserController.resetPassword(
      email: _emailController.text.trim(),
      code: _codeController.text.trim(),
      newPassword: _newPasswordController.text,
    );

    if (ok && mounted) {
      Get.back();
      MySnackBar.showSnackBarSuccess('¡Contraseña actualizada! Ya puedes iniciar sesión');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Recuperar Contraseña'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Constants.border(context), width: 1.2),
              ),
              child: !_codeSent ? _buildStep1() : _buildStep2(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _step1Key,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Constants.surfaceLight(context),
                shape: BoxShape.circle,
                border: Border.all(color: Constants.border(context)),
              ),
              child: Icon(
                Icons.lock_reset_rounded,
                size: 38,
                color: Constants.accent(context),
              ),
            ),
          ),
          const Gap(16),
          MyText(
            '¿Olvidaste tu contraseña?',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Constants.textPrimary(context),
            textAlign: TextAlign.center,
          ),
          const Gap(6),
          MyText(
            'Ingresa el correo electrónico de tu cuenta y te enviaremos un código de 6 dígitos para restablecerla.',
            fontSize: 13,
            color: Constants.textSecondary(context),
            textAlign: TextAlign.center,
          ),
          const Gap(22),
          MyTextField(
            controller: _emailController,
            text: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) => Validations.validateEmail(value),
          ),
          const Gap(22),
          MyButton(
            text: 'Enviar código a mi correo',
            onPressed: _sendRecoveryCode,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, color: Constants.primaryContent(context), size: 17),
                const Gap(8),
                MyText(
                  'Enviar código a mi correo',
                  color: Constants.primaryContent(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _step2Key,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Constants.kSageGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.key_rounded,
                size: 36,
                color: Constants.kSageGreen,
              ),
            ),
          ),
          const Gap(14),
          MyText(
            'Crea tu nueva contraseña',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Constants.textPrimary(context),
            textAlign: TextAlign.center,
          ),
          const Gap(6),
          MyText(
            'Ingresa el código enviado a ${_emailController.text.trim()} y elige tu nueva contraseña.',
            fontSize: 12.5,
            color: Constants.textSecondary(context),
            textAlign: TextAlign.center,
          ),
          const Gap(20),

          // Campo de código de 6 dígitos
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              color: Constants.textPrimary(context),
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 6,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Código 6 dígitos',
              hintStyle: TextStyle(
                color: Constants.textSecondary(context).withValues(alpha: 0.5),
                fontSize: 14,
                letterSpacing: 2,
              ),
              filled: true,
              fillColor: Constants.surfaceLight(context),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                borderSide: BorderSide(color: Constants.accent(context), width: 1.5),
              ),
            ),
          ),
          const Gap(14),

          MyPasswordField(
            controller: _newPasswordController,
            text: 'Nueva contraseña',
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            validator: (value) => Validations.validatePassword(value),
          ),
          const Gap(12),

          MyPasswordField(
            controller: _confirmPasswordController,
            text: 'Confirmar nueva contraseña',
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: const Icon(Icons.lock_reset_rounded),
            validator: (value) => Validations.validateConfirmPassword(
              value,
              _newPasswordController.text,
            ),
          ),
          const Gap(22),

          MyButton(
            text: 'Actualizar contraseña',
            onPressed: _resetPassword,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline_rounded, color: Constants.primaryContent(context), size: 18),
                const Gap(8),
                MyText(
                  'Actualizar contraseña',
                  color: Constants.primaryContent(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          const Gap(10),
          TextButton(
            onPressed: () {
              setState(() {
                _codeSent = false;
              });
            },
            child: MyText(
              'Cambiar correo o reenviar código',
              fontSize: 12.5,
              color: Constants.accent(context),
            ),
          ),
        ],
      ),
    );
  }
}
