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
  final Color color;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.child,
    this.color = Constants.kPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: color,
        elevation: 3,
        shadowColor: color.withValues(alpha: 0.35),
        maximumSize: Size(width ?? double.infinity, height ?? 52),
        minimumSize: Size(width ?? double.infinity, height ?? 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: child ??
          MyText(
            text,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
    );
  }
}
