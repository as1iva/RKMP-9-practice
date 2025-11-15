import 'package:get_it/get_it.dart';
import 'package:practice_9/services/image_service.dart';
import 'package:practice_9/services/profile_service.dart';
import 'package:practice_9/services/auth_service.dart';
import 'package:practice_9/features/books/data/datasources/movies_local_datasource.dart';
import 'package:practice_9/features/books/data/repositories/movies_repository.dart';
import 'package:practice_9/features/books/data/repositories/movies_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<MoviesLocalDataSource>(MoviesLocalDataSource());

  getIt.registerSingleton<MoviesRepository>(
    MoviesRepositoryImpl(localDataSource: getIt<MoviesLocalDataSource>()),
  );

  getIt.registerSingleton<ImageService>(ImageService());

  await getIt<ImageService>().initialize();

  getIt.registerSingleton<ProfileService>(ProfileService());

  getIt.registerSingleton<AuthService>(AuthService());
}

class Services {
  static ImageService get image => getIt<ImageService>();
  static ProfileService get profile => getIt<ProfileService>();
  static AuthService get auth => getIt<AuthService>();
}

class Repositories {
  static MoviesRepository get movies => getIt<MoviesRepository>();
}
