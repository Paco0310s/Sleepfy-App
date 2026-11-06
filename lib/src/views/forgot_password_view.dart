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
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Recuperar Contraseña'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Constants.kSurfaceColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Constants.kBorderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Constants.kPrimaryColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                size: 46,
                color: Constants.kSecondaryColor,
              ),
            ),
          ),
          const Gap(18),
          const MyText(
            '¿Olvidaste tu contraseña?',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Constants.kTextColor,
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          const MyText(
            'Ingresa el correo electrónico de tu cuenta y te enviaremos un código de 6 dígitos para restablecerla.',
            fontSize: 13.5,
            color: Constants.kTextSecondaryColor,
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          MyTextField(
            controller: _emailController,
            text: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) => Validations.validateEmail(value),
          ),
          const Gap(24),
          MyButton(
            color: Constants.kPrimaryColor,
            text: 'Enviar código a mi correo',
            onPressed: _sendRecoveryCode,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, color: Colors.white, size: 18),
                Gap(10),
                MyText(
                  'Enviar código a mi correo',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
                color: Constants.kMintColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.key_rounded,
                size: 40,
                color: Constants.kMintColor,
              ),
            ),
          ),
          const Gap(14),
          const MyText(
            'Crea tu nueva contraseña',
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Constants.kTextColor,
            textAlign: TextAlign.center,
          ),
          const Gap(6),
          MyText(
            'Ingresa el código enviado a ${_emailController.text.trim()} y elige tu nueva contraseña.',
            fontSize: 13,
            color: Constants.kTextSecondaryColor,
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
            style: const TextStyle(
              color: Constants.kSecondaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Código 6 dígitos',
              hintStyle: TextStyle(
                color: Constants.kTextSecondaryColor.withValues(alpha: 0.4),
                fontSize: 16,
                letterSpacing: 2,
              ),
              filled: true,
              fillColor: Constants.kBackgroundColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Constants.kBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Constants.kBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Constants.kSecondaryColor, width: 1.8),
              ),
            ),
          ),
          const Gap(16),

          MyPasswordField(
            controller: _newPasswordController,
            text: 'Nueva contraseña',
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            validator: (value) => Validations.validatePassword(value),
          ),
          const Gap(14),

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
          const Gap(24),

          MyButton(
            color: Constants.kPrimaryColor,
            text: 'Actualizar contraseña',
            onPressed: _resetPassword,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
                Gap(8),
                MyText(
                  'Actualizar contraseña',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
            child: const MyText(
              'Cambiar correo o reenviar código',
              fontSize: 12.5,
              color: Constants.kSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
