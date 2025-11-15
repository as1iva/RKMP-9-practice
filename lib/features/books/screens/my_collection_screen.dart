import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_state.dart';
import 'package:practice_9/features/books/widgets/movie_tile.dart';
import 'package:practice_9/shared/widgets/empty_state.dart';

class MovieCollectionScreen extends StatelessWidget {
  const MovieCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя коллекция'),
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! MoviesLoaded) {
            return const Center(child: Text('Не удалось загрузить фильмы'));
          }

          if (state.movies.isEmpty) {
            return const EmptyState(
              icon: Icons.local_movies,
              title: 'Коллекция пуста',
              subtitle: 'Добавьте фильмы в свою коллекцию',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.movies.length,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
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
