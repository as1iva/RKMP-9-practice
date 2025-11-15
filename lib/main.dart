import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_9/app.dart';
import 'package:practice_9/core/di/service_locator.dart';
import 'package:practice_9/core/bloc/app_bloc_observer.dart';
import 'package:practice_9/services/logger_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  await setupServiceLocator();

  Services.image.preloadImagePool().catchError((e) {
    LoggerService.warning('Предзагрузка изображений не удалась (возможно, нет интернета): $e');
  });

  runApp(const MoviesApp());
}
