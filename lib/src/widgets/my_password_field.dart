import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleepfy/src/widgets/my_text_field.dart';
import 'package:sleepfy/src/widgets/my_visibility_toggle.dart';

class MyPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String text;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  const MyPasswordField({
    super.key,
    this.text = 'Contraseña',
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.prefixIcon,
    this.validator,
  });

  @override
  State<MyPasswordField> createState() => _MyPasswordFieldState();
}

class _MyPasswordFieldState extends State<MyPasswordField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      text: widget.text,
      controller: widget.controller,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      obscureText: isObscure,
      onChanged: widget.onChanged,
      prefixIcon: widget.prefixIcon,
      suffixIcon: MyVisibilityToggle(
        isObscure: isObscure,
        onPressed: () {
          setState(() {
            isObscure = !isObscure;
          });
        },
      ),
    );
  }
}
