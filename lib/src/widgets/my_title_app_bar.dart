import 'package:flutter/material.dart';
import 'package:sleepfy/src/utils/constants.dart';

class MyTitleAppBar extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  const MyTitleAppBar({
    super.key,
    required this.title,
    this.fontSize = 18,
    this.color = Constants.kTextColor,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: 0.2,
      ),
    );
  }
}
