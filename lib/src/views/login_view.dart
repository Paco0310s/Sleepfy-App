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
      body: Form(
        key: userProvider.formKeyLogin,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Gap(20),
              SizedBox(height: 200, child: _HeaderLogin()),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Constants.kSecondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const MyText(
                        'Iniciar sesión con tu cuenta para continuar',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                        color: Constants.kPrimaryColor,
                      ),
                      const Gap(30),
                      const EmailFieldItem(),
                      const Gap(20),
                      PasswordFieldItem(userProvider: userProvider),
                      const Gap(40),
                      LoginButton(userProvider: userProvider),
                      const Gap(10),
                      RegisterButton(userProvider: userProvider),
                      // _ForgotPassword(userProvider: userProvider),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderLogin extends StatelessWidget {
  const _HeaderLogin();

  @override
  Widget build(BuildContext context) {
    // Imagen de la cabecera
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Constants.kBackgroundColor,
        image: DecorationImage(
          image: AssetImage('assets/images/icon.png'),
          fit: BoxFit.fitHeight,
        ),
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(5),
        //   bottomRight: Radius.circular(5),
        // ),
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
      prefixIcon: const Icon(Icons.email),
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
      prefixIcon: const Icon(Icons.lock),
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.login),
          Gap(10),
          MyText('Iniciar sesión'),
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
      color: Constants.kPrimaryColor.withValues(alpha: 0.7),
      text: 'Registrarse',
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add),
          Gap(10),
          MyText('Registrarse'),
        ],
      ),
      onPressed: () {
        userProvider.toRegister();
      },
    );
  }
}

// class _ForgotPassword extends StatelessWidget {
//   final UserProvider userProvider;

//   const _ForgotPassword({
//     required this.userProvider,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         userProvider.resetPassword();
//       },
//       child: const Text(
//         'Olvidé mi contraseña',
//         style: TextStyle(color: Constants.kSecondaryColor),
//       ),
//     );
//   }
// }
