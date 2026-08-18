import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/controllers/user_controller.dart';
import 'package:sleepfy/models/user_model.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/home_view.dart';
import 'package:sleepfy/src/views/register_view.dart';

class UserProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyRegister = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  void login() async {
    if (!formKeyLogin.currentState!.validate()) {
      return MySnackBar.showSnackBarError('Verifique los campos');
    }

    final String email = emailController.text;
    final String password = passwordController.text;

    final data = {
      'email': email,
      'password': password,
    };

    final UserModel? user = await UserController.login(data);

    if (user != null) {
      await UserPreferences.setToken(user.token);
      await UserPreferences.setId(user.id);
      await UserPreferences.setName(user.name);
      await UserPreferences.setLastName(user.lastName);
      await UserPreferences.setEmail(user.email);

      emailController.clear();
      passwordController.clear();

      final TestProvider testProvider = Provider.of<TestProvider>(Get.context!, listen: false);
      testProvider.init();

      Get.offAll(() => const HomeView());
      MySnackBar.showSnackBarSuccess('Bienvenido ${user.name} ${user.lastName}');
    }
  }

  void resetPassword() {}

  void register() async {
    if (!formKeyRegister.currentState!.validate()) {
      return MySnackBar.showSnackBarError('Verifique los campos');
    }

    final String name = nameController.text;
    final String lastName = lastNameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    final data = {
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
    };

    final user = await UserController.register(data);

    if (user != null) {
      await UserPreferences.setToken(user.token);
      await UserPreferences.setId(user.id);
      await UserPreferences.setName(user.name);
      await UserPreferences.setLastName(user.lastName);
      await UserPreferences.setEmail(user.email);

      nameController.clear();
      lastNameController.clear();
      emailController.clear();
      passwordController.clear();

      final TestProvider testProvider = Provider.of<TestProvider>(Get.context!, listen: false);
      testProvider.init();

      Get.offAll(() => const HomeView());
      MySnackBar.showSnackBarSuccess('Bienvenido ${user.name} ${user.lastName}');
    }
  }

  void toRegister() {
    Get.to(() => const RegisterView());
  }
}
