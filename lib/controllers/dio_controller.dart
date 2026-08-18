import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:sleepfy/models/response_model.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_loading.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/login_view.dart';
import 'package:sleepfy/src/widgets/my_text.dart';

class DioController {
  static Dio get instance => _dio;
  // static const String _baseUrl = 'http://localhost:3000/api/';
  // static const String _baseUrl = 'http://192.168.137.1:3000/api/';
  static const String _baseUrl = 'https://sleepfy.api.pacosotelo.com/api/';
  static final Dio _dio = Dio(BaseOptions(contentType: Headers.jsonContentType, responseType: ResponseType.json))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final headers = options.headers;
          headers.addAll({'authorization': 'Bearer ${UserPreferences.token}'});
          handler.next(options);
        },
      ),
    );

  static Future<ResponseModel> petition(HTTPMethods method, String url, {Map<String, dynamic>? data, bool showLoading = true}) async {
    try {
      Response response;
      if (getx.Get.isSnackbarOpen) getx.Get.back();
      if (!MyLoading.isLoading && !getx.Get.isSnackbarOpen && showLoading) MyLoading.showLoading();
      // await Future.delayed(const Duration(seconds: 1));
      switch (method) {
        case HTTPMethods.get:
          response = await _dio.get(_baseUrl + url);
          break;
        case HTTPMethods.post:
          response = await _dio.post(_baseUrl + url, data: data);
          break;
        case HTTPMethods.put:
          response = await _dio.put(_baseUrl + url, data: data);
          break;
        case HTTPMethods.delete:
          response = await _dio.delete(_baseUrl + url);
          break;
      }
      if (MyLoading.isLoading) MyLoading.closeLoading();
      return ResponseModel(message: response.statusMessage ?? '', data: response.data, status: response.statusCode);
    } on DioException catch (e) {
      debugPrint(e.toString());

      if (MyLoading.isLoading) MyLoading.closeLoading();
      String? message = e.response?.data['message'] ?? e.response?.data['error'];

      switch (e.type) {
        case DioExceptionType.receiveTimeout:
          MySnackBar.showSnackBarError('Tiempo de espera de respuesta agotado');
          break;
        case DioExceptionType.sendTimeout:
          MySnackBar.showSnackBarError('Tiempo de espera de envío agotado');
          break;
        case DioExceptionType.cancel:
          MySnackBar.showSnackBarError('Petición cancelada');
          break;
        case DioExceptionType.connectionTimeout:
          MySnackBar.showSnackBarError('Tiempo de espera de conexión agotado');
          break;
        case DioExceptionType.badCertificate:
          toLogin();
          MySnackBar.showSnackBarError('Su sesión ha expirado, inicie sesión nuevamente');
          break;
        case DioExceptionType.badResponse:
          MySnackBar.showSnackBarError(message ?? 'Ocurrió un error, intente nuevamente');
          break;
        case DioExceptionType.connectionError:
          getx.Get.off(() => const ReloadView());
          MySnackBar.showSnackBarError('Verifique su conexión a internet');
          break;
        case DioExceptionType.unknown:
          MySnackBar.showSnackBarError('Error desconocido');
          break;
      }

      if (e.response?.statusCode == 401) toLogin();

      return ResponseModel(message: message ?? 'Ocurrió un error, intente nuevamente', data: e.response?.data, status: e.response?.statusCode);
    }
  }

  static void toLogin() {
    UserPreferences.removeToken();
    getx.Get.offAll(() => const LoginView());
  }
}

class ReloadView extends StatelessWidget {
  const ReloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                'Verifique su conexión a internet y reinicie la aplicación',
                textAlign: TextAlign.center,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Constants.kBackgroundColor,
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     getx.Get.back();
              //   },
              //   child: const Text('Reintentar'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

enum HTTPMethods { get, post, put, delete }
