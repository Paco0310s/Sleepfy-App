import 'package:flutter/material.dart';

class MyVisibilityToggle extends StatelessWidget {
  final bool isObscure;
  final void Function() onPressed;

  const MyVisibilityToggle({super.key, required this.isObscure, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
      onPressed: onPressed,
    );
  }
}