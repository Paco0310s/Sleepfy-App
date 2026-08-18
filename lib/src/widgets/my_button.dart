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
          padding: padding,
          backgroundColor: color,
          maximumSize: Size(width ?? double.infinity, height ?? 50),
          minimumSize: Size(width ?? double.infinity, height ?? 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: Constants.kSecondaryColor,
        ),
        onPressed: onPressed,
        child: child ?? MyText(text, fontSize: 16, fontWeight: FontWeight.bold));
  }
}
