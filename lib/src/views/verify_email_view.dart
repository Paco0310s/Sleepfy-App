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
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Verificar Correo'),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Constants.surfaceLight(context),
                      shape: BoxShape.circle,
                      border: Border.all(color: Constants.border(context)),
                    ),
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      size: 38,
                      color: Constants.accent(context),
                    ),
                  ),
                  const Gap(16),
                  MyText(
                    'Confirma tu correo electrónico',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Constants.textPrimary(context),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(6),
                  MyText(
                    'Enviamos un código de verificación de 6 dígitos a:\n${widget.email}',
                    fontSize: 13,
                    color: Constants.textSecondary(context),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(22),

                  // Input de 6 dígitos estilizado
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                      color: Constants.textPrimary(context),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '000000',
                      hintStyle: TextStyle(
                        color: Constants.textSecondary(context).withValues(alpha: 0.35),
                        fontSize: 26,
                        letterSpacing: 8,
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
                    onSubmitted: (_) => _onVerify(),
                  ),
                  const Gap(22),

                  MyButton(
                    text: 'Verificar y continuar',
                    onPressed: _onVerify,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_rounded, color: Constants.primaryContent(context), size: 19),
                        const Gap(8),
                        MyText(
                          'Verificar y continuar',
                          color: Constants.primaryContent(context),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ],
                    ),
                  ),
                  const Gap(14),

                  TextButton.icon(
                    onPressed: _resendCooldown > 0 ? null : _onResend,
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 16,
                      color: _resendCooldown > 0
                          ? Constants.textSecondary(context).withValues(alpha: 0.5)
                          : Constants.accent(context),
                    ),
                    label: MyText(
                      _resendCooldown > 0
                          ? 'Reenviar código en ${_resendCooldown}s'
                          : '¿No recibiste el código? Reenviar ahora',
                      fontSize: 12.5,
                      color: _resendCooldown > 0
                          ? Constants.textSecondary(context)
                          : Constants.accent(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(4),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: MyText(
                      'Volver al inicio de sesión',
                      fontSize: 12,
                      color: Constants.textSecondary(context),
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
