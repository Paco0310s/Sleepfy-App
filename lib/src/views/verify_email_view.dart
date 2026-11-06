import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/controllers/user_controller.dart';
import 'package:sleepfy/src/providers/user_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class VerifyEmailView extends StatefulWidget {
  final String email;

  const VerifyEmailView({super.key, required this.email});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final TextEditingController _codeController = TextEditingController();
  int _resendCooldown = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() {
      _resendCooldown = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendCooldown <= 1) {
        timer.cancel();
        setState(() {
          _resendCooldown = 0;
        });
      } else {
        setState(() {
          _resendCooldown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onVerify() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      MySnackBar.showSnackBarError('Ingresa el código de 6 dígitos');
      return;
    }

    final user = await UserController.verifyEmail(widget.email, code);
    if (user != null && mounted) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.completeSessionLogin(user);
    }
  }

  Future<void> _onResend() async {
    if (_resendCooldown > 0) return;
    final ok = await UserController.resendVerification(widget.email);
    if (ok) {
      MySnackBar.showSnackBarSuccess('Te enviamos un nuevo código a ${widget.email}');
      _startCooldown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Verificar Correo'),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Constants.kPrimaryColor.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mark_email_read_outlined,
                      size: 46,
                      color: Constants.kSecondaryColor,
                    ),
                  ),
                  const Gap(18),
                  const MyText(
                    'Confirma tu correo electrónico',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Constants.kTextColor,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  MyText(
                    'Enviamos un código de verificación de 6 dígitos a:\n${widget.email}',
                    fontSize: 13.5,
                    color: Constants.kTextSecondaryColor,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(24),

                  // Input de 6 dígitos estilizado
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      color: Constants.kSecondaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 10,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '000000',
                      hintStyle: TextStyle(
                        color: Constants.kTextSecondaryColor.withValues(alpha: 0.35),
                        fontSize: 28,
                        letterSpacing: 10,
                      ),
                      filled: true,
                      fillColor: Constants.kBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Constants.kBorderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Constants.kBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Constants.kSecondaryColor, width: 1.8),
                      ),
                    ),
                    onSubmitted: (_) => _onVerify(),
                  ),
                  const Gap(24),

                  MyButton(
                    color: Constants.kPrimaryColor,
                    text: 'Verificar y continuar',
                    onPressed: _onVerify,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                        Gap(8),
                        MyText(
                          'Verificar y continuar',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  const Gap(14),

                  TextButton.icon(
                    onPressed: _resendCooldown > 0 ? null : _onResend,
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: _resendCooldown > 0
                          ? Constants.kTextSecondaryColor.withValues(alpha: 0.5)
                          : Constants.kSecondaryColor,
                    ),
                    label: MyText(
                      _resendCooldown > 0
                          ? 'Reenviar código en ${_resendCooldown}s'
                          : '¿No recibiste el código? Reenviar ahora',
                      fontSize: 13,
                      color: _resendCooldown > 0
                          ? Constants.kTextSecondaryColor
                          : Constants.kSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(6),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const MyText(
                      'Volver al inicio de sesión',
                      fontSize: 12.5,
                      color: Constants.kTextSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
