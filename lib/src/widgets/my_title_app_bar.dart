import 'package:flutter/material.dart';
import 'package:sleepfy/src/utils/constants.dart';

class MyTitleAppBar extends StatelessWidget {
  final String title;
  final Color? color;
  final double fontSize;

  const MyTitleAppBar({
    super.key,
    required this.title,
    this.color,
    this.fontSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color ?? Constants.textPrimary(context),
      ),
    );
  }
}
