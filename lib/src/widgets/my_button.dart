import 'package:flutter/material.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_text.dart';

class MyButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Function() onPressed;
  final Widget? child;
  final Color? color;
  final Color? textColor;
  final bool outlined;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.child,
    this.color,
    this.textColor,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Constants.primary(context);
    final effectiveTextColor = textColor ??
        (color != null ? Colors.white : Constants.primaryContent(context));

    if (outlined) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          side: BorderSide(color: Constants.border(context), width: 1.2),
          maximumSize: Size(width ?? double.infinity, height ?? 50),
          minimumSize: Size(width ?? double.infinity, height ?? 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          foregroundColor: Constants.textPrimary(context),
        ),
        onPressed: onPressed,
        child: child ??
            MyText(
              text,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Constants.textPrimary(context),
            ),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: effectiveColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        maximumSize: Size(width ?? double.infinity, height ?? 50),
        minimumSize: Size(width ?? double.infinity, height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        foregroundColor: effectiveTextColor,
      ),
      onPressed: onPressed,
      child: child ??
          MyText(
            text,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: effectiveTextColor,
          ),
    );
  }
}
