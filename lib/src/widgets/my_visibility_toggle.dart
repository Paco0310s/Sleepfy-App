import 'package:flutter/material.dart';
import 'package:sleepfy/src/utils/constants.dart';

class MyVisibilityToggle extends StatelessWidget {
  final bool isObscure;
  final void Function() onPressed;

  const MyVisibilityToggle({super.key, required this.isObscure, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: isObscure ? Constants.kTextSecondaryColor : Constants.kSecondaryColor,
        size: 20,
      ),
      tooltip: isObscure ? 'Mostrar contraseña' : 'Ocultar contraseña',
      onPressed: onPressed,
    );
  }
}