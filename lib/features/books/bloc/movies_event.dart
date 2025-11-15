import 'package:equatable/equatable.dart';
import 'package:practice_9/features/books/models/movie.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovies extends MoviesEvent {
  const LoadMovies();
}

class AddMovie extends MoviesEvent {
  final Movie movie;

  const AddMovie(this.movie);

  @override
  List<Object?> get props => [movie];
}

class UpdateMovie extends MoviesEvent {
  final Movie movie;

  const UpdateMovie(this.movie);

  @override
  List<Object?> get props => [movie];
}

class DeleteMovie extends MoviesEvent {
  final String movieId;

  const DeleteMovie(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class ToggleMovieWatched extends MoviesEvent {
  final String movieId;
  final bool isWatched;

  const ToggleMovieWatched(this.movieId, this.isWatched);

  @override
  List<Object?> get props => [movieId, isWatched];
}

class UpdateMovieRating extends MoviesEvent {
  final String movieId;
  final int rating;

  const UpdateMovieRating(this.movieId, this.rating);

  @override
  List<Object?> get props => [movieId, rating];
}
