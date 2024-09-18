import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/sensy_interceptor.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureInjection() async => await getIt.init();

@module
abstract class Module {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  PrettyDioLogger get prettyDioLogger => PrettyDioLogger(
        requestHeader: false,
        queryParameters: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
        showProcessingTime: false,
        showCUrl: true,
        canShowLog: true,
      );

  @lazySingleton
  Dio dio(
    SensyInterceptor sensyInterceptor,
    PrettyDioLogger prettyDioLogger,
  ) {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.sendTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 40);
    dio.interceptors.add(sensyInterceptor);
    if (kDebugMode) {
      dio.interceptors.add(prettyDioLogger);
    }
    return dio;
  }
}
