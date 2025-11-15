import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_event.dart';
import 'package:practice_9/features/books/bloc/movies_state.dart';
import 'package:practice_9/features/books/models/movie.dart';
import 'package:practice_9/features/books/data/repositories/movies_repository.dart';
import 'package:practice_9/core/di/service_locator.dart';
import 'package:practice_9/services/logger_service.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository _repository;

  MoviesBloc({required MoviesRepository repository})
      : _repository = repository,
        super(const MoviesInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<AddMovie>(_onAddMovie);
    on<UpdateMovie>(_onUpdateMovie);
    on<DeleteMovie>(_onDeleteMovie);
    on<ToggleMovieWatched>(_onToggleMovieWatched);
    on<UpdateMovieRating>(_onUpdateMovieRating);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<MoviesState> emit) async {
    try {
      emit(const MoviesLoading());
      final movies = await _repository.getMovies();
      emit(MoviesLoaded(movies));
      LoggerService.info('Фильмы загружены: ${movies.length} шт.');
    } catch (e) {
      LoggerService.error('Ошибка загрузки фильмов: $e');
      emit(MoviesError('Не удалось загрузить фильмы: $e'));
    }
  }

  Future<void> _onAddMovie(AddMovie event, Emitter<MoviesState> emit) async {
    try {
      if (state is MoviesLoaded) {
        final currentState = state as MoviesLoaded;

        final imageUrl = await Services.image.getNextMovieImage();
        final movieWithImage = event.movie.copyWith(imageUrl: imageUrl);

        await _repository.addMovie(movieWithImage);

        final updatedMovies = List<Movie>.from(currentState.movies)..add(movieWithImage);

        emit(MoviesLoaded(updatedMovies));

        LoggerService.info('Фильм добавлен: ${movieWithImage.title}');
      }
    } catch (e) {
      LoggerService.error('Ошибка добавления фильма: $e');
      emit(MoviesError('Не удалось добавить фильм: $e'));
    }
  }

  Future<void> _onUpdateMovie(UpdateMovie event, Emitter<MoviesState> emit) async {
    try {
      if (state is MoviesLoaded) {
        final currentState = state as MoviesLoaded;

        await _repository.updateMovie(event.movie);

        final updatedMovies = currentState.movies.map((movie) {
          return movie.id == event.movie.id ? event.movie : movie;
        }).toList();

        emit(MoviesLoaded(updatedMovies));
        LoggerService.info('Фильм обновлён: ${event.movie.title}');
      }
    } catch (e) {
      LoggerService.error('Ошибка обновления фильма: $e');
      emit(MoviesError('Не удалось обновить фильм: $e'));
    }
  }

  Future<void> _onDeleteMovie(DeleteMovie event, Emitter<MoviesState> emit) async {
    try {
      if (state is MoviesLoaded) {
        final currentState = state as MoviesLoaded;
        final movieToDelete = currentState.movies.firstWhere((movie) => movie.id == event.movieId);

        if (movieToDelete.imageUrl != null) {
          await Services.image.releaseImage(movieToDelete.imageUrl!);
        }

        await _repository.deleteMovie(event.movieId);

        final updatedMovies =
            currentState.movies.where((movie) => movie.id != event.movieId).toList();

        emit(MoviesLoaded(updatedMovies));

        LoggerService.info('Фильм удалён: ${movieToDelete.title}');
      }
    } catch (e) {
      LoggerService.error('Ошибка удаления фильма: $e');
      emit(MoviesError('Не удалось удалить фильм: $e'));
    }
  }

  Future<void> _onToggleMovieWatched(
      ToggleMovieWatched event, Emitter<MoviesState> emit) async {
    try {
      if (state is MoviesLoaded) {
        final currentState = state as MoviesLoaded;
        final updatedMovies = currentState.movies.map((movie) {
          if (movie.id == event.movieId) {
            return movie.copyWith(
              isWatched: event.isWatched,
              dateWatched: event.isWatched ? DateTime.now() : null,
            );
          }
          return movie;
        }).toList();

        final updatedMovie = updatedMovies.firstWhere((m) => m.id == event.movieId);
        await _repository.updateMovie(updatedMovie);

        emit(MoviesLoaded(updatedMovies));
        LoggerService.info('Статус просмотра изменён для фильма ID: ${event.movieId}');
      }
    } catch (e) {
      LoggerService.error('Ошибка изменения статуса просмотра: $e');
      emit(MoviesError('Не удалось изменить статус просмотра: $e'));
    }
  }

  Future<void> _onUpdateMovieRating(
      UpdateMovieRating event, Emitter<MoviesState> emit) async {
    try {
      if (state is MoviesLoaded) {
        final currentState = state as MoviesLoaded;
        final updatedMovies = currentState.movies.map((movie) {
          if (movie.id == event.movieId) {
            return movie.copyWith(rating: event.rating);
          }
          return movie;
        }).toList();

        final updatedMovie = updatedMovies.firstWhere((m) => m.id == event.movieId);
        await _repository.updateMovie(updatedMovie);

        emit(MoviesLoaded(updatedMovies));
        LoggerService.info(
            'Оценка фильма изменена ID: ${event.movieId}, рейтинг: ${event.rating}');
      }
    } catch (e) {
      LoggerService.error('Ошибка оценки фильма: $e');
      emit(MoviesError('Не удалось оценить фильм: $e'));
    }
  }
}
