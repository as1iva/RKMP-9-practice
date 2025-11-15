import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:practice_9/features/books/bloc/movies_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_event.dart';
import 'package:practice_9/features/books/models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Movie _movie;

  @override
  void initState() {
    super.initState();
    _movie = widget.movie;
  }

  void _toggleWatched() {
    final nextValue = !_movie.isWatched;
    context.read<MoviesBloc>().add(ToggleMovieWatched(_movie.id, nextValue));
    setState(() {
      _movie = _movie.copyWith(
        isWatched: nextValue,
        dateWatched: nextValue ? DateTime.now() : null,
      );
    });
  }

  void _openEdit() {
    context.push('/movie-form', extra: {
      'movie': _movie,
      'onSave': (Movie updated) {
        context.read<MoviesBloc>().add(UpdateMovie(updated));
        setState(() => _movie = updated);
        context.pop();
      },
    });
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Оценить фильм'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final rating = index + 1;
            return IconButton(
              icon: Icon(
                rating <= (_movie.rating ?? 0) ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                context.read<MoviesBloc>().add(UpdateMovieRating(_movie.id, rating));
                setState(() => _movie = _movie.copyWith(rating: rating));
                Navigator.pop(dialogContext);
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить фильм?'),
        content: Text('Вы уверены, что хотите удалить «${_movie.title}»?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<MoviesBloc>().add(DeleteMovie(_movie.id));
              Navigator.pop(dialogContext);
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(_movie.title),
        actions: [
          IconButton(onPressed: _openEdit, icon: const Icon(Icons.edit)),
          IconButton(onPressed: _confirmDelete, icon: const Icon(Icons.delete_outline)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: _movie.imageUrl == null
                  ? Container(
                      color: Colors.black12,
                      child: const Center(
                        child: Icon(Icons.local_movies, size: 48),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: _movie.imageUrl!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _movie.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Режиссёр: ${_movie.director}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _InfoRow(
            icon: Icons.category,
            label: 'Жанр',
            value: _movie.genre,
          ),
          if (_movie.runtimeMinutes != null)
            _InfoRow(
              icon: Icons.schedule,
              label: 'Хронометраж',
              value: '${_movie.runtimeMinutes} мин',
            ),
          _InfoRow(
            icon: Icons.calendar_month,
            label: 'Добавлено',
            value: dateFormat.format(_movie.dateAdded),
          ),
          if (_movie.dateWatched != null)
            _InfoRow(
              icon: Icons.check,
              label: 'Просмотрено',
              value: dateFormat.format(_movie.dateWatched!),
            ),
          if (_movie.description != null && _movie.description!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Описание',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(_movie.description!),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _toggleWatched,
                  icon: Icon(_movie.isWatched ? Icons.undo : Icons.check_circle),
                  label: Text(_movie.isWatched ? 'Вернуть в планы' : 'Отметить просмотренным'),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: _showRatingDialog,
                icon: const Icon(Icons.star),
                label: const Text('Оценить'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
