import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' as getx;
import 'package:sleepfy/models/response_model.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_loading.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/breathing_exercise_view.dart';
import 'package:sleepfy/src/views/home_view.dart';
import 'package:sleepfy/src/views/login_view.dart';
import 'package:sleepfy/src/views/sleep_calculator_view.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';

class DioController {
  static Dio get instance => _dio;
  static String get baseUrl => _baseUrl;
  // Support configurable API URL via --dart-define=API_URL=...
  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://sleepfy.api.pacosotelo.com/api/',
  );
  static Completer<bool>? _refreshCompleter;

  static Future<bool> _refreshAccessToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final refreshToken = UserPreferences.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    try {
      final refreshDio = Dio(
        BaseOptions(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );
      final resp = await refreshDio.post(
        '${_baseUrl}auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final map = resp.data as Map<String, dynamic>;
        final newAccess = (map['token'] ?? map['access_token'])?.toString();
        final newRefresh = (map['refreshToken'] ?? map['refresh_token'])?.toString();

        if (newAccess != null && newAccess.isNotEmpty) {
          await UserPreferences.setToken(newAccess);
          if (newRefresh != null && newRefresh.isNotEmpty) {
            await UserPreferences.setRefreshToken(newRefresh);
          }
          completer.complete(true);
          return true;
        }
      }
      completer.complete(false);
      return false;
    } catch (_) {
      completer.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  static final Dio _dio = Dio(
    BaseOptions(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 25),
      receiveTimeout: const Duration(seconds: 45),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final headers = options.headers;
          headers.addAll({'authorization': 'Bearer ${UserPreferences.token}'});
          handler.next(options);
        },
        onError: (err, handler) async {
          final statusCode = err.response?.statusCode;
          final path = err.requestOptions.path;
          final isAuthRoute = path.contains('auth/login') ||
              path.contains('auth/register') ||
              path.contains('auth/refresh');
          final alreadyRetried = err.requestOptions.extra['_retried'] == true;

          if (statusCode == 401 && !isAuthRoute && !alreadyRetried) {
            final refreshed = await _refreshAccessToken();
            if (refreshed && err.requestOptions.data is! FormData) {
              err.requestOptions.extra['_retried'] = true;
              err.requestOptions.headers['authorization'] = 'Bearer ${UserPreferences.token}';
              try {
                final retryResponse = await _dio.fetch(err.requestOptions);
                return handler.resolve(retryResponse);
              } catch (retryErr) {
                if (retryErr is DioException) {
                  return handler.next(retryErr);
                }
              }
            }
          }
          handler.next(err);
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
        case HTTPMethods.patch:
          response = await _dio.patch(_baseUrl + url, data: data);
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
      String? message;
      final respData = e.response?.data;
      if (respData is Map) {
        final rawMsg = respData['message'] ?? respData['error'];
        if (rawMsg is List && rawMsg.isNotEmpty) {
          message = rawMsg.first.toString();
        } else if (rawMsg != null) {
          message = rawMsg.toString();
        }
      }

      if (showLoading) {
        if (e.type == DioExceptionType.receiveTimeout) {
          MySnackBar.showSnackBarError('Tiempo de espera de respuesta agotado');
        } else if (e.type == DioExceptionType.sendTimeout) {
          MySnackBar.showSnackBarError('Tiempo de espera de envío agotado');
        } else if (e.type == DioExceptionType.cancel) {
          MySnackBar.showSnackBarError('Petición cancelada');
        } else if (e.type == DioExceptionType.connectionTimeout) {
          MySnackBar.showSnackBarError('Tiempo de espera de conexión agotado');
        } else if (e.type == DioExceptionType.badCertificate) {
          toLogin();
          MySnackBar.showSnackBarError('Su sesión ha expirado, inicie sesión nuevamente');
        } else if (e.type == DioExceptionType.badResponse) {
          MySnackBar.showSnackBarError(message ?? 'Ocurrió un error, intente nuevamente');
        } else if (e.type == DioExceptionType.connectionError) {
          if (UserPreferences.token == null) {
            MySnackBar.showSnackBarError('Verifique su conexión a internet');
          } else {
            getx.Get.to(() => const ReloadView());
          }
        } else if (e.type == DioExceptionType.unknown) {
          MySnackBar.showSnackBarError('Error desconocido');
        } else {
          MySnackBar.showSnackBarError(message ?? 'Error de conexión');
        }
      }

      if (e.response?.statusCode == 401) toLogin();

      return ResponseModel(message: message ?? 'Ocurrió un error, intente nuevamente', data: e.response?.data, status: e.response?.statusCode);
    }
  }

  static Future<ResponseModel> uploadFile(
    String url,
    String fieldName,
    List<int> bytes,
    String filename, {
    bool showLoading = true,
  }) async {
    try {
      if (getx.Get.isSnackbarOpen) getx.Get.back();
      if (!MyLoading.isLoading && !getx.Get.isSnackbarOpen && showLoading) MyLoading.showLoading();

      final formData = FormData.fromMap({
        fieldName: MultipartFile.fromBytes(bytes, filename: filename),
      });

      final response = await _dio.post(
        _baseUrl + url,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      if (MyLoading.isLoading) MyLoading.closeLoading();
      return ResponseModel(message: response.statusMessage ?? '', data: response.data, status: response.statusCode);
    } on DioException catch (e) {
      debugPrint(e.toString());
      if (MyLoading.isLoading) MyLoading.closeLoading();
      String? message;
      final respData = e.response?.data;
      if (respData is Map) {
        final rawMsg = respData['message'] ?? respData['error'];
        if (rawMsg is List && rawMsg.isNotEmpty) {
          message = rawMsg.first.toString();
        } else if (rawMsg != null) {
          message = rawMsg.toString();
        }
      }
      if (showLoading) {
        MySnackBar.showSnackBarError(message ?? 'Error al subir el archivo');
      }
      if (e.response?.statusCode == 401) toLogin();
      return ResponseModel(message: message ?? 'Error al subir el archivo', data: e.response?.data, status: e.response?.statusCode);
    }
  }

  static void toLogin() async {
    await UserPreferences.logout();
    getx.Get.offAll(() => const LoginView());
  }
}

class ReloadView extends StatelessWidget {
  const ReloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Constants.kSurfaceColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Constants.kBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Constants.kWarningColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wifi_off_rounded,
                      size: 46,
                      color: Constants.kWarningColor,
                    ),
                  ),
                  const Gap(18),
                  const MyText(
                    'Sin conexión con el servidor',
                    textAlign: TextAlign.center,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Constants.kTextColor,
                  ),
                  const Gap(8),
                  const MyText(
                    'Verifica tu conexión a internet. Mientras tanto, puedes seguir usando tus herramientas de descanso en Modo Offline.',
                    textAlign: TextAlign.center,
                    fontSize: 13.5,
                    color: Constants.kTextSecondaryColor,
                  ),
                  const Gap(24),
                  MyButton(
                    color: Constants.kPrimaryColor,
                    text: 'Volver al Inicio / Reintentar',
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                        Gap(8),
                        MyText(
                          'Volver al Inicio / Reintentar',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (UserPreferences.token != null) {
                        getx.Get.offAll(() => const HomeView());
                      } else {
                        getx.Get.offAll(() => const LoginView());
                      }
                    },
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Constants.kBorderColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.air_rounded, color: Constants.kMintColor, size: 18),
                          label: const MyText('Respirar 4-7-8', fontSize: 12.5, color: Constants.kTextColor),
                          onPressed: () => getx.Get.to(() => const BreathingExerciseView()),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Constants.kBorderColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.calculate_outlined, color: Constants.kSecondaryColor, size: 18),
                          label: const MyText('Ciclos 90m', fontSize: 12.5, color: Constants.kTextColor),
                          onPressed: () => getx.Get.to(() => const SleepCalculatorView()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum HTTPMethods { get, post, put, patch, delete }
