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
      backgroundColor: Constants.kBackgroundColor,
      body: SafeArea(
        child: Form(
          key: userProvider.formKeyLogin,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Logo con halo de luz
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Constants.kPrimaryColor.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Gap(16),
                  const MyText(
                    'Sleepfy',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Constants.kTextColor,
                  ),
                  const Gap(6),
                  const MyText(
                    'Bienvenido de nuevo a tu espacio de descanso',
                    fontSize: 14,
                    color: Constants.kTextSecondaryColor,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(28),

                  // Tarjeta del formulario
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Constants.kSurfaceColor,
                      borderRadius: BorderRadius.circular(20),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const MyText(
                          'Iniciar Sesión',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Constants.kTextColor,
                        ),
                        const Gap(6),
                        const MyText(
                          'Ingresa tus datos para continuar',
                          fontSize: 13,
                          color: Constants.kTextSecondaryColor,
                        ),
                        const Gap(24),
                        const EmailFieldItem(),
                        const Gap(16),
                        PasswordFieldItem(userProvider: userProvider),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => userProvider.toForgotPassword(),
                            child: const MyText(
                              '¿Olvidaste tu contraseña?',
                              fontSize: 13,
                              color: Constants.kSecondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Gap(14),
                        LoginButton(userProvider: userProvider),
                        const Gap(14),
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
  const EmailFieldItem({
    super.key,
  });

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
      color: Constants.kPrimaryColor,
      text: 'Iniciar sesión',
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.login_rounded, size: 20, color: Colors.white),
          Gap(10),
          MyText(
            'Iniciar sesión',
            color: Colors.white,
            fontWeight: FontWeight.w600,
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
      color: Constants.kSurfaceLightColor,
      text: 'Crear una cuenta',
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_alt_1_outlined, size: 20, color: Constants.kSecondaryColor),
          Gap(10),
          MyText(
            'Crear una cuenta',
            color: Constants.kTextColor,
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
