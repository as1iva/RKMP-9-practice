import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! MoviesLoaded) {
            return const Center(child: Text('Нет данных'));
          }

          final progress =
              state.totalMovies == 0 ? 0 : (state.watchedMovies / state.totalMovies * 100);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatCard(
                title: 'Общее',
                rows: [
                  _StatRow('Всего фильмов', state.totalMovies.toString()),
                  _StatRow('Просмотрено', state.watchedMovies.toString()),
                  _StatRow('Хочу посмотреть', state.watchlistMovies.toString()),
                  _StatRow('Прогресс', '${progress.toStringAsFixed(0)}%'),
                ],
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: 'Оценки',
                rows: [
                  _StatRow('Средняя оценка', state.averageRating.toStringAsFixed(1)),
                  _StatRow(
                    'Оценено фильмов',
                    state.movies.where((m) => m.rating != null).length.toString(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: 'Жанры',
                rows: _buildGenreRows(state),
              ),
            ],
          );
        },
      ),
    );
  }

  List<_StatRow> _buildGenreRows(MoviesLoaded state) {
    final map = <String, int>{};
    for (final movie in state.movies) {
      map[movie.genre] = (map[movie.genre] ?? 0) + 1;
    }
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty) {
      return [const _StatRow('Нет данных', '-')];
    }

    return entries.map((entry) => _StatRow(entry.key, entry.value.toString())).toList();
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final List<_StatRow> rows;

  const _StatCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
