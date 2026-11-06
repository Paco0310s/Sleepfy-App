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
      style: const TextStyle(
        color: Constants.kTextColor,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Constants.kSurfaceColor,
        labelText: text,
        labelStyle: const TextStyle(
          color: Constants.kTextSecondaryColor,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: Constants.kSecondaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        prefixIconColor: Constants.kSecondaryColor,
        suffixIconColor: Constants.kTextSecondaryColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constants.kBorderColor,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constants.kPrimaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constants.kErrorColor,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constants.kErrorColor,
            width: 2.0,
          ),
        ),
      ),
      cursorErrorColor: Constants.kErrorColor,
      cursorColor: Constants.kSecondaryColor,
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
      style: const TextStyle(
        color: Constants.kTextColor,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Constants.kSurfaceColor,
        hintText: text,
        hintStyle: const TextStyle(
          color: Constants.kTextSecondaryColor,
          fontSize: 14,
        ),
        prefixIconColor: Constants.kSecondaryColor,
        suffixIconColor: Constants.kTextSecondaryColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constants.kBorderColor,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constants.kPrimaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constants.kErrorColor,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constants.kErrorColor,
            width: 2.0,
          ),
        ),
      ),
      cursorErrorColor: Constants.kErrorColor,
      cursorColor: Constants.kSecondaryColor,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
