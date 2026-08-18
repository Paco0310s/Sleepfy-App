import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleepfy/src/utils/constants.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String text;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const MyTextField({
    super.key,
    required this.text,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Constants.kSecondaryColor,
        labelText: text,
        labelStyle: const TextStyle(
          color: Constants.kBackgroundColor,
        ),
        floatingLabelStyle: const TextStyle(
          color: Constants.kBackgroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        hoverColor: Constants.kSecondaryColor.withValues(alpha: 0.05),
        prefixIconColor: Constants.kPrimaryColor,
        suffixIconColor: Constants.kPrimaryColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Constants.kPrimaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Constants.kPrimaryColor,
            width: 3,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Constants.kErrorColor, // Borde cuando hay un error
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Constants.kErrorColor, // Borde cuando hay un error y el campo está enfocado
            width: 2.0,
          ),
        ),
      ),
      cursorErrorColor: Constants.kErrorColor,
      cursorColor: Constants.kPrimaryColor,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}

class MyTextField2 extends StatelessWidget {
  final TextEditingController? controller;
  final String text;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const MyTextField2({
    super.key,
    required this.text,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        // filled: true,
        fillColor: Constants.kSecondaryColor,
        // labelText: text,
        labelStyle: const TextStyle(
          color: Constants.kBackgroundColor,
        ),
        // floatingLabelStyle: const TextStyle(
        //   color: Constants.kBackgroundColor,
        //   fontWeight: FontWeight.bold,
        //   fontSize: 18,
        // ),
        hintText: text,
        hoverColor: Constants.kSecondaryColor.withValues(alpha: 0.05),
        prefixIconColor: Constants.kPrimaryColor,
        suffixIconColor: Constants.kPrimaryColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Constants.kPrimaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Constants.kPrimaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Constants.kErrorColor, // Borde cuando hay un error
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Constants.kErrorColor, // Borde cuando hay un error y el campo está enfocado
            width: 2.0,
          ),
        ),
      ),
      cursorErrorColor: Constants.kErrorColor,
      cursorColor: Constants.kPrimaryColor,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
