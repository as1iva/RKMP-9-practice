import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_state.dart';
import 'package:practice_9/features/books/widgets/movie_tile.dart';
import 'package:practice_9/shared/widgets/empty_state.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Хочу посмотреть'),
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is! MoviesLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final watchlist = state.watchlistMoviesList
            ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

          return watchlist.isEmpty
              ? const EmptyState(
                  icon: Icons.watch_later_outlined,
                  title: 'Список пуст',
                  subtitle: 'Добавьте фильмы, которые хотите посмотреть',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: watchlist.length,
                  itemBuilder: (context, index) {
                    final movie = watchlist[index];
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
