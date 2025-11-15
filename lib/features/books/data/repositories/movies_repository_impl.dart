import 'package:practice_9/features/books/models/movie.dart';
import 'package:practice_9/features/books/data/repositories/movies_repository.dart';
import 'package:practice_9/features/books/data/datasources/movies_local_datasource.dart';
import 'package:practice_9/services/logger_service.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesLocalDataSource _localDataSource;

  MoviesRepositoryImpl({
    required MoviesLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<List<Movie>> getMovies() async {
    try {
      return await _localDataSource.getMovies();
    } catch (e) {
      LoggerService.error('MoviesRepository: Ошибка получения фильмов: $e');
      rethrow;
    }
  }

  @override
  Future<void> addMovie(Movie movie) async {
    try {
      final movies = await getMovies();
      movies.add(movie);
      await _localDataSource.saveMovies(movies);
      LoggerService.info('MoviesRepository: Фильм добавлен: ${movie.title}');
    } catch (e) {
      LoggerService.error('MoviesRepository: Ошибка добавления фильма: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateMovie(Movie movie) async {
    try {
      final movies = await getMovies();
      final index = movies.indexWhere((m) => m.id == movie.id);

      if (index != -1) {
        movies[index] = movie;
        await _localDataSource.saveMovies(movies);
        LoggerService.info('MoviesRepository: Фильм обновлён: ${movie.title}');
      } else {
        throw Exception('Фильм с ID ${movie.id} не найден');
      }
    } catch (e) {
      LoggerService.error('MoviesRepository: Ошибка обновления фильма: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMovie(String id) async {
    try {
      final movies = await getMovies();
      movies.removeWhere((movie) => movie.id == id);
      await _localDataSource.saveMovies(movies);
      LoggerService.info('MoviesRepository: Фильм удалён: $id');
    } catch (e) {
      LoggerService.error('MoviesRepository: Ошибка удаления фильма: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveMovies(List<Movie> movies) async {
    try {
      await _localDataSource.saveMovies(movies);
    } catch (e) {
      LoggerService.error('MoviesRepository: Ошибка сохранения фильмов: $e');
      rethrow;
    }
  }
}
