import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MySnackBar {
  static void showSnackBarSuccess( String message) {
    Get.snackbar(
      'Exito',
      message,
      maxWidth: 400,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 5),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(10),
      shouldIconPulse: true,
      icon: const Icon(Icons.check_circle, color: Colors.white,),
    );
  }

  static void showSnackBarError( String message) {
    Get.snackbar(
      'Error',
      message,
      maxWidth: 400,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 5),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(10),
      shouldIconPulse: true,
      icon: const Icon(Icons.error, color: Colors.white,),
    );
  }

  static void showSnackBarInfo( String message) {
    Get.snackbar(
      'Informacion',
      message,
      maxWidth: 400,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 5),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(10),
      shouldIconPulse: true,
      icon: const Icon(Icons.info, color: Colors.white,),
    );
  }

  static void showSnackBarWarning( String message) {
    Get.snackbar(
      'Advertencia',
      message,
      maxWidth: 400,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 5),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(10),
      shouldIconPulse: true,
      icon: const Icon(Icons.warning, color: Colors.white,),
    );
  }
}