import 'package:flutter/material.dart';

// import 'package:flutter_svg/flutter_svg.dart';

class MyImageSVG extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;

  const MyImageSVG(this.assetName, {super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      // child: SvgPicture.asset(
      //   assetName,
      //   width: width,
      //   height: height,
      // ),
    );
  }
}
