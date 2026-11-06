import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/src/functions/validations.dart';
import 'package:sleepfy/src/providers/user_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/widgets/widgets.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
      body: SafeArea(
        child: Form(
          key: userProvider.formKeyRegister,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Logo
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Constants.kPrimaryColor.withValues(alpha: 0.3),
                          blurRadius: 25,
                          spreadRadius: 4,
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
                    'Crear Cuenta',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Constants.kTextColor,
                  ),
                  const Gap(6),
                  const MyText(
                    'Únete a Sleepfy y comienza a transformar tu descanso',
                    fontSize: 13.5,
                    color: Constants.kTextSecondaryColor,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(24),

                  // Form Card
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
                        const NameFieldItem(),
                        const Gap(16),
                        const LastNameFieldItem(),
                        const Gap(16),
                        const EmailFieldItem(),
                        const Gap(16),
                        PasswordFieldItem(userProvider: userProvider),
                        const Gap(28),
                        RegisterButton(userProvider: userProvider),
                        const Gap(12),
                        ToBackButton(userProvider: userProvider),
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

class NameFieldItem extends StatelessWidget {
  const NameFieldItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return MyTextField(
      controller: userProvider.nameController,
      text: 'Nombre',
      keyboardType: TextInputType.text,
      prefixIcon: const Icon(Icons.person_outline_rounded),
      validator: (value) => Validations.validateName(value),
    );
  }
}

class LastNameFieldItem extends StatelessWidget {
  const LastNameFieldItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return MyTextField(
      controller: userProvider.lastNameController,
      text: 'Apellido',
      keyboardType: TextInputType.text,
      prefixIcon: const Icon(Icons.badge_outlined),
      validator: (value) => Validations.validateLastName(value),
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

class RegisterButton extends StatelessWidget {
  final UserProvider userProvider;

  const RegisterButton({
    super.key,
    required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      color: Constants.kPrimaryColor,
      text: 'Crear cuenta',
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_rounded, size: 20, color: Colors.white),
          Gap(10),
          MyText(
            'Crear cuenta',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
      onPressed: () {
        userProvider.register();
      },
    );
  }
}

class ToBackButton extends StatelessWidget {
  final UserProvider userProvider;

  const ToBackButton({
    super.key,
    required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      color: Constants.kSurfaceLightColor,
      text: 'Ya tengo cuenta, iniciar sesión',
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_rounded, size: 18, color: Constants.kSecondaryColor),
          Gap(8),
          MyText(
            'Ya tengo cuenta, iniciar sesión',
            color: Constants.kTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
      onPressed: () {
        Get.back();
      },
    );
  }
}
