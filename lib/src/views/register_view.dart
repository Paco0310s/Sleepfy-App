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
      backgroundColor: Constants.background(context),
      body: SafeArea(
        child: Form(
          key: userProvider.formKeyRegister,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
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
                    'Crear Cuenta',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Constants.textPrimary(context),
                  ),
                  const Gap(4),
                  MyText(
                    'Únete a Sleepfy y comienza a transformar tu descanso',
                    fontSize: 13,
                    color: Constants.textSecondary(context),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(24),

                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Constants.surface(context),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Constants.border(context), width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const NameFieldItem(),
                        const Gap(14),
                        const LastNameFieldItem(),
                        const Gap(14),
                        const EmailFieldItem(),
                        const Gap(14),
                        PasswordFieldItem(userProvider: userProvider),
                        const Gap(24),
                        RegisterButton(userProvider: userProvider),
                        const Gap(10),
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
  const NameFieldItem({super.key});

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
  const LastNameFieldItem({super.key});

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

class RegisterButton extends StatelessWidget {
  final UserProvider userProvider;

  const RegisterButton({
    super.key,
    required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      text: 'Crear cuenta',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_rounded, size: 19, color: Constants.primaryContent(context)),
          const Gap(8),
          MyText(
            'Crear cuenta',
            color: Constants.primaryContent(context),
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
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
      outlined: true,
      text: 'Ya tengo cuenta, iniciar sesión',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_rounded, size: 17, color: Constants.textPrimary(context)),
          const Gap(8),
          MyText(
            'Ya tengo cuenta, iniciar sesión',
            color: Constants.textPrimary(context),
            fontSize: 13.5,
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
