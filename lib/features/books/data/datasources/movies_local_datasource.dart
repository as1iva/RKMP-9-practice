import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practice_9/features/books/models/movie.dart';
import 'package:practice_9/services/logger_service.dart';

class MoviesLocalDataSource {
  static const String _moviesKey = 'movies_data';

  Future<List<Movie>> getMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? moviesJson = prefs.getString(_moviesKey);

      if (moviesJson == null || moviesJson.isEmpty) {
        LoggerService.info('MoviesLocalDataSource: Нет сохранённых фильмов');
        return [];
      }

      final List<dynamic> decoded = json.decode(moviesJson);
      final movies = decoded.map((json) => _movieFromJson(json)).toList();

      LoggerService.info('MoviesLocalDataSource: Загружено ${movies.length} фильмов');
      return movies;
    } catch (e) {
      LoggerService.error('MoviesLocalDataSource: Ошибка загрузки фильмов: $e');
      return [];
    }
  }

  Future<void> saveMovies(List<Movie> movies) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final moviesJson = json.encode(movies.map((movie) => _movieToJson(movie)).toList());
      await prefs.setString(_moviesKey, moviesJson);

      LoggerService.info('MoviesLocalDataSource: Сохранено ${movies.length} фильмов');
    } catch (e) {
      LoggerService.error('MoviesLocalDataSource: Ошибка сохранения фильмов: $e');
      rethrow;
    }
  }

  Future<void> clearMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_moviesKey);
      LoggerService.info('MoviesLocalDataSource: Фильмы удалены из хранилища');
    } catch (e) {
      LoggerService.error('MoviesLocalDataSource: Ошибка очистки фильмов: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _movieToJson(Movie movie) {
    return {
      'id': movie.id,
      'title': movie.title,
      'director': movie.director,
      'genre': movie.genre,
      'description': movie.description,
      'runtimeMinutes': movie.runtimeMinutes,
      'isWatched': movie.isWatched,
      'rating': movie.rating,
      'dateAdded': movie.dateAdded.toIso8601String(),
      'dateWatched': movie.dateWatched?.toIso8601String(),
      'imageUrl': movie.imageUrl,
    };
  }

  Movie _movieFromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      director: json['director'] as String,
      genre: json['genre'] as String,
      description: json['description'] as String?,
      runtimeMinutes: json['runtimeMinutes'] as int?,
      isWatched: json['isWatched'] as bool? ?? false,
      rating: json['rating'] as int?,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      dateWatched: json['dateWatched'] != null
          ? DateTime.parse(json['dateWatched'] as String)
          : null,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
