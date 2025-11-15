import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_state.dart';
import 'package:practice_9/features/books/widgets/movie_tile.dart';
import 'package:practice_9/shared/widgets/empty_state.dart';

class WatchedMoviesScreen extends StatelessWidget {
  const WatchedMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Просмотренные фильмы'),
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is! MoviesLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final watched = state.watchedMoviesList
            ..sort((a, b) {
              if (a.dateWatched == null && b.dateWatched == null) return 0;
              if (a.dateWatched == null) return 1;
              if (b.dateWatched == null) return -1;
              return b.dateWatched!.compareTo(a.dateWatched!);
            });

          return watched.isEmpty
              ? const EmptyState(
                  icon: Icons.local_movies_outlined,
                  title: 'Список пуст',
                  subtitle: 'Отметьте фильмы как просмотренные',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: watched.length,
                  itemBuilder: (context, index) {
                    final movie = watched[index];
                    return MovieTile(
                      key: ValueKey(movie.id),
                      movie: movie,
                    );
                  },
                );
        },
      ),
    );
  }
}
