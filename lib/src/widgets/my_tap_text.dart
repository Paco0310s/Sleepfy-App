import 'package:flutter/material.dart';
import 'package:sleepfy/src/widgets/my_text.dart';

class MyTapText extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const MyTapText({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: MyText(
        text,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
