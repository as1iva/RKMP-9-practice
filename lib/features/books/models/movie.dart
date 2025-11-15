import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String director;
  final String genre;
  final String? description;
  final int? runtimeMinutes;
  final bool isWatched;
  final int? rating;
  final DateTime dateAdded;
  final DateTime? dateWatched;
  final String? imageUrl;

  const Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.genre,
    this.description,
    this.runtimeMinutes,
    this.isWatched = false,
    this.rating,
    required this.dateAdded,
    this.dateWatched,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        director,
        genre,
        description,
        runtimeMinutes,
        isWatched,
        rating,
        dateAdded,
        dateWatched,
        imageUrl,
      ];

  Movie copyWith({
    String? id,
    String? title,
    String? director,
    String? genre,
    String? description,
    int? runtimeMinutes,
    bool? isWatched,
    int? rating,
    DateTime? dateAdded,
    DateTime? dateWatched,
    String? imageUrl,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      runtimeMinutes: runtimeMinutes ?? this.runtimeMinutes,
      isWatched: isWatched ?? this.isWatched,
      rating: rating ?? this.rating,
      dateAdded: dateAdded ?? this.dateAdded,
      dateWatched: dateWatched ?? this.dateWatched,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
