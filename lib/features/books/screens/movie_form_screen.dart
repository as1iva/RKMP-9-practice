import 'package:flutter/material.dart';
import 'package:practice_9/features/books/models/movie.dart';
import 'package:practice_9/shared/constants.dart';

class MovieFormScreen extends StatefulWidget {
  final Function(Movie) onSave;
  final Movie? movie;

  const MovieFormScreen({
    super.key,
    required this.onSave,
    this.movie,
  });

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _directorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _runtimeController = TextEditingController();
  String _selectedGenre = AppConstants.genres.first;

  @override
  void initState() {
    super.initState();
    final movie = widget.movie;
    if (movie != null) {
      _titleController.text = movie.title;
      _directorController.text = movie.director;
      _descriptionController.text = movie.description ?? '';
      _runtimeController.text = movie.runtimeMinutes?.toString() ?? '';
      _selectedGenre = movie.genre;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _descriptionController.dispose();
    _runtimeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final runtime = _runtimeController.text.trim().isEmpty
        ? null
        : int.tryParse(_runtimeController.text.trim());

    final movie = (widget.movie ?? _emptyMovie()).copyWith(
      title: _titleController.text.trim(),
      director: _directorController.text.trim(),
      genre: _selectedGenre,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      runtimeMinutes: runtime,
    );

    widget.onSave(movie);
  }

  Movie _emptyMovie() {
    return Movie(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      director: '',
      genre: _selectedGenre,
      runtimeMinutes: null,
      description: null,
      isWatched: false,
      rating: null,
      dateAdded: DateTime.now(),
      dateWatched: null,
      imageUrl: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать фильм' : 'Добавить фильм'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название *',
                  prefixIcon: Icon(Icons.movie_creation_outlined),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _directorController,
                decoration: const InputDecoration(
                  labelText: 'Режиссёр *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Введите режиссёра' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedGenre,
                decoration: const InputDecoration(
                  labelText: 'Жанр',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: AppConstants.genres
                    .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedGenre = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _runtimeController,
                decoration: const InputDecoration(
                  labelText: 'Хронометраж (мин)',
                  prefixIcon: Icon(Icons.timelapse_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (int.tryParse(value.trim()) == null) {
                      return 'Введите корректное значение';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                  label: Text(isEditing ? 'Сохранить' : 'Добавить фильм'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
