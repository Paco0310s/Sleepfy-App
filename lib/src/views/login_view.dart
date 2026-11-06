import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/src/functions/validations.dart';
import 'package:sleepfy/src/providers/user_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/widgets/widgets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Constants.background(context),
      body: SafeArea(
        child: Form(
          key: userProvider.formKeyLogin,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Logo limpio con sutil borde
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Constants.border(context),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Gap(16),
                  MyText(
                    'Sleepfy',
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Constants.textPrimary(context),
                  ),
                  const Gap(4),
                  MyText(
                    'Bienvenido de nuevo a tu espacio de descanso',
                    fontSize: 13.5,
                    color: Constants.textSecondary(context),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(28),

                  // Tarjeta del formulario
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Constants.surface(context),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Constants.border(context), width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyText(
                          'Iniciar Sesión',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Constants.textPrimary(context),
                        ),
                        const Gap(4),
                        MyText(
                          'Ingresa tus datos para continuar',
                          fontSize: 12.5,
                          color: Constants.textSecondary(context),
                        ),
                        const Gap(22),
                        const EmailFieldItem(),
                        const Gap(14),
                        PasswordFieldItem(userProvider: userProvider),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => userProvider.toForgotPassword(),
                            child: MyText(
                              '¿Olvidaste tu contraseña?',
                              fontSize: 12.5,
                              color: Constants.accent(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Gap(10),
                        LoginButton(userProvider: userProvider),
                        const Gap(12),
                        RegisterButton(userProvider: userProvider),
                      ],
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

class EmailFieldItem extends StatelessWidget {
  const EmailFieldItem({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return MyTextField(
      controller: userProvider.emailController,
      text: 'Correo electrónico',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
      validator: (value) => Validations.validateEmail(value),
    );
  }
}

class PasswordFieldItem extends StatelessWidget {
  final UserProvider userProvider;

  const PasswordFieldItem({
    super.key,
    required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MyPasswordField(
      controller: userProvider.passwordController,
      text: 'Contraseña',
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: const Icon(Icons.lock_outline_rounded),
      validator: (value) => Validations.validatePassword(value),
    );
  }
}

class LoginButton extends StatelessWidget {
  final UserProvider userProvider;

  const LoginButton({
    super.key,
    required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      text: 'Iniciar sesión',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.login_rounded, size: 19, color: Constants.primaryContent(context)),
          const Gap(8),
          MyText(
            'Iniciar sesión',
            color: Constants.primaryContent(context),
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
          ),
        ],
      ),
      onPressed: () {
        userProvider.login();
      },
    );
  }
}

class RegisterButton extends StatelessWidget {
  final UserProvider userProvider;

  const RegisterButton({
    super.key,
    required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      outlined: true,
      text: 'Crear una cuenta',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_alt_1_outlined, size: 19, color: Constants.textPrimary(context)),
          const Gap(8),
          MyText(
            'Crear una cuenta',
            color: Constants.textPrimary(context),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
      onPressed: () {
        userProvider.toRegister();
      },
    );
  }
}
