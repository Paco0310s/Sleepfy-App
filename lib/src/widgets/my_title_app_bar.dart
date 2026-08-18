import 'package:flutter/material.dart';

class MyTitleAppBar extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  const MyTitleAppBar({
    super.key,
    required this.title,
    this.fontSize = 18,
    this.color = const Color(0xFF212529),
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
