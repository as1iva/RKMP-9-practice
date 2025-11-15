import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_9/features/books/bloc/movies_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_event.dart';
import 'package:practice_9/features/books/bloc/movies_state.dart';
import 'package:practice_9/features/books/widgets/movie_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _addMovie(BuildContext context) {
    context.push('/movie-form', extra: {
      'onSave': (movie) {
        context.read<MoviesBloc>().add(AddMovie(movie));
        context.pop();
      },
    });
  }

  void _openProfile(BuildContext context) => context.push('/profile');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмотека'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Профиль',
            onPressed: () => _openProfile(context),
          ),
        ],
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MoviesError) {
            return Center(child: Text(state.message));
          }

          if (state is! MoviesLoaded) {
            return const SizedBox.shrink();
          }

          final total = state.totalMovies;
          final watched = state.watchedMovies;
          final watchlist = state.watchlistMovies;
          final averageRating = state.averageRating;
          final recent = state.recentMovies;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HeroCard(
                total: total,
                watched: watched,
                watchlist: watchlist,
                averageRating: averageRating,
              ),
              const SizedBox(height: 24),
              Text(
                'Недавно добавленные',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (recent.isEmpty)
                const Text('Добавьте фильмы, чтобы они появились здесь.')
              else
                ...recent.map(
                  (movie) => MovieTile(
                    key: ValueKey(movie.id),
                    movie: movie,
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMovie(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final int total;
  final int watched;
  final int watchlist;
  final double averageRating;

  const _HeroCard({
    required this.total,
    required this.watched,
    required this.watchlist,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Всего фильмов: $total',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatBlock(
                  label: 'Просмотрено',
                  value: watched.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatBlock(
                  label: 'В планах',
                  value: watchlist.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatBlock(
                  label: 'Средняя оценка',
                  value: averageRating.toStringAsFixed(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => context.push('/watched-movies'),
                icon: const Icon(Icons.playlist_add_check),
                label: const Text('Просмотренные'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.push('/watchlist'),
                icon: const Icon(Icons.visibility),
                label: const Text('Хочу посмотреть'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.push('/statistics'),
                icon: const Icon(Icons.bar_chart),
                label: const Text('Статистика'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.push('/ratings'),
                icon: const Icon(Icons.star_border),
                label: const Text('Оценки'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;

  const _StatBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
