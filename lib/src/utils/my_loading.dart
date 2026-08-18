import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:sleepfy/src/utils/constants.dart';

class MyLoading {
  static bool isLoading = false;

  static Future<dynamic> showLoading() async {
    if (Get.context == null) return;

    isLoading = true;

    return showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: Constants.kPrimaryColor, backgroundColor: Colors.white),
        );
      },
    );
  }

  static void closeLoading() {
    isLoading = false;
    Get.back();
  }
}
