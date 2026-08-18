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
      body: Form(
        key: userProvider.formKeyRegister,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 128,
                  height: 128,
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
                ),
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
                          'Regístrate para continuar',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                          color: Constants.kPrimaryColor,
                        ),
                        const Gap(30),
                        const NameFieldItem(),
                        const Gap(20),
                        const LastNameFieldItem(),
                        const Gap(20),
                        const EmailFieldItem(),
                        const Gap(20),
                        PasswordFieldItem(userProvider: userProvider),
                        const Gap(40),
                        RegisterButton(userProvider: userProvider),
                        const Gap(10),
                        ToBackButton(userProvider: userProvider),
                        // _ForgotPassword(userProvider: userProvider),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _HeaderLogin extends StatelessWidget {
//   const _HeaderLogin();

//   @override
//   Widget build(BuildContext context) {
//     // Imagen de la cabecera
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: const BoxDecoration(
//         color: Constants.kBackgroundColor,
//         image: DecorationImage(
//           image: AssetImage('assets/images/icon.png'),
//           fit: BoxFit.fitHeight,
//         ),
//         // borderRadius: BorderRadius.only(
//         //   bottomLeft: Radius.circular(5),
//         //   bottomRight: Radius.circular(5),
//         // ),
//       ),
//     );
//   }
// }

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
      prefixIcon: const Icon(Icons.person),
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
      prefixIcon: const Icon(Icons.person_4),
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

class RegisterButton extends StatelessWidget {
  final UserProvider userProvider;

  const RegisterButton({
    super.key,
    required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
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
      color: Constants.kPrimaryColor.withValues(alpha: 0.7),
      text: 'Volver',
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back),
          Gap(10),
          MyText('Volver'),
        ],
      ),
      onPressed: () {
        Get.back();
      },
    );
  }
}
