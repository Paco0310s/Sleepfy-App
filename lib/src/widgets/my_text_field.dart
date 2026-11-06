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
      style: TextStyle(
        color: Constants.textPrimary(context),
        fontSize: 14.5,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Constants.surface(context),
        labelText: text,
        labelStyle: TextStyle(
          color: Constants.textSecondary(context),
          fontSize: 13.5,
        ),
        floatingLabelStyle: TextStyle(
          color: Constants.textPrimary(context),
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        prefixIconColor: Constants.textSecondary(context),
        suffixIconColor: Constants.textSecondary(context),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Constants.border(context),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Constants.textPrimary(context),
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constants.kErrorColor,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constants.kErrorColor,
            width: 1.4,
          ),
        ),
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
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
      style: TextStyle(
        color: Constants.textPrimary(context),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Constants.surfaceLight(context),
        hintText: text,
        hintStyle: TextStyle(
          color: Constants.textSecondary(context),
          fontSize: 13.5,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Constants.border(context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Constants.border(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Constants.textPrimary(context), width: 1.2),
        ),
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
