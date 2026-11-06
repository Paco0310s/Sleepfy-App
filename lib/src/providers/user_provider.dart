import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/controllers/user_controller.dart';
import 'package:sleepfy/models/response_model.dart';
import 'package:sleepfy/models/user_model.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/forgot_password_view.dart';
import 'package:sleepfy/src/views/home_view.dart';
import 'package:sleepfy/src/views/register_view.dart';
import 'package:sleepfy/src/views/verify_email_view.dart';

class UserProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyRegister = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  Future<void> completeSessionLogin(UserModel user) async {
    await UserPreferences.setToken(user.token);
    await UserPreferences.setId(user.id);
    await UserPreferences.setName(user.name);
    await UserPreferences.setLastName(user.lastName);
    await UserPreferences.setEmail(user.email);

    nameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();

    if (Get.context != null) {
      final TestProvider testProvider = Provider.of<TestProvider>(Get.context!, listen: false);
      testProvider.init();
      final ControlDreamsProvider dreamsProvider = Provider.of<ControlDreamsProvider>(Get.context!, listen: false);
      dreamsProvider.init();
    }

    Get.offAll(() => const HomeView());
    MySnackBar.showSnackBarSuccess('Bienvenido ${user.name} ${user.lastName}');
  }

  void login() async {
    if (!formKeyLogin.currentState!.validate()) {
      return MySnackBar.showSnackBarError('Verifique los campos');
    }

    final String email = emailController.text.trim();
    final String password = passwordController.text;

    final data = {
      'email': email,
      'password': password,
    };

    final ResponseModel resp = await UserController.loginRaw(data);

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      final map = resp.data as Map<String, dynamic>;
      if (map['requiresVerification'] == true) {
        MySnackBar.showSnackBarSuccess(
          map['message']?.toString() ?? 'Verifica tu correo electrónico para continuar',
        );
        Get.to(() => VerifyEmailView(email: email));
        return;
      }

      final user = UserModel.fromJson(map);
      await completeSessionLogin(user);
    }
  }

  void toForgotPassword() {
    Get.to(() => ForgotPasswordView(initialEmail: emailController.text.trim()));
  }

  void register() async {
    if (!formKeyRegister.currentState!.validate()) {
      return MySnackBar.showSnackBarError('Verifique los campos');
    }

    final String name = nameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    final data = {
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
    };

    final ResponseModel resp = await UserController.registerRaw(data);

    if (resp.status == 201 && resp.data is Map<String, dynamic>) {
      final map = resp.data as Map<String, dynamic>;
      if (map['requiresVerification'] == true) {
        MySnackBar.showSnackBarSuccess(
          map['message']?.toString() ?? 'Te enviamos un código de 6 dígitos a tu correo',
        );
        Get.to(() => VerifyEmailView(email: email));
        return;
      }

      final user = UserModel.fromJson(map);
      await completeSessionLogin(user);
    }
  }

  void toRegister() {
    Get.to(() => const RegisterView());
  }
}
