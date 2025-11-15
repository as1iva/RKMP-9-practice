import 'package:practice_9/features/books/models/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getMovies();

  Future<void> addMovie(Movie movie);

  Future<void> updateMovie(Movie movie);

  Future<void> deleteMovie(String id);

  Future<void> saveMovies(List<Movie> movies);
}
