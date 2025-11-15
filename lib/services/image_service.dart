import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practice_9/services/logger_service.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  static const int _avatarPoolSize = 10;
  static const String _keyUsedImages = 'used_images';
  static const String _keyAvailableImages = 'available_images';
  static const String _keyUsedAvatars = 'used_avatars';
  static const String _keyAvailableAvatars = 'available_avatars';

  static const List<String> _moviePosters = [
    'https://image.tmdb.org/t/p/w500/5P8SmMzSNYikXpxil6BYzJ16611.jpg',
    'https://image.tmdb.org/t/p/w500/6o0UWX2naW7HK45PDNYmoMIk5qs.jpg',
    'https://image.tmdb.org/t/p/w500/hpU2cHC9tk90hswCFEpf5AtbqoL.jpg',
    'https://image.tmdb.org/t/p/w500/94kQGMiFbs5MUTlt7kj9dewsMDi.jpg',
    'https://image.tmdb.org/t/p/w500/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg',
    'https://image.tmdb.org/t/p/w500/2CAL2433ZeIihfX1Hb2139CX0pW.jpg',
    'https://image.tmdb.org/t/p/w500/rCzpDGLbOoPwLjy3OAm5NUPOTrC.jpg',
    'https://image.tmdb.org/t/p/w500/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg',
    'https://image.tmdb.org/t/p/w500/jtp3J7827oLusdFHBRdMcXfQe5U.jpg',
    'https://image.tmdb.org/t/p/w500/aKuFiU82s5ISJpGZp7YkIr3kCUd.jpg',
  ];

  List<String> _availableImages = [];
  Set<String> _usedImages = {};
  List<String> _availableAvatars = [];
  Set<String> _usedAvatars = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();

    final usedImagesJson = prefs.getString(_keyUsedImages);
    final availableImagesJson = prefs.getString(_keyAvailableImages);
    final usedAvatarsJson = prefs.getString(_keyUsedAvatars);
    final availableAvatarsJson = prefs.getString(_keyAvailableAvatars);

    if (usedImagesJson != null) {
      _usedImages = Set<String>.from(jsonDecode(usedImagesJson));
    }
    if (availableImagesJson != null) {
      _availableImages = List<String>.from(jsonDecode(availableImagesJson));
    }
    if (usedAvatarsJson != null) {
      _usedAvatars = Set<String>.from(jsonDecode(usedAvatarsJson));
    }
    if (availableAvatarsJson != null) {
      _availableAvatars = List<String>.from(jsonDecode(availableAvatarsJson));
    }

    if (_availableImages.isEmpty) {
      await _generateImagePool();
    }

    if (_availableAvatars.isEmpty) {
      await _generateAvatarPool();
    }

    _isInitialized = true;
  }

  Future<void> _generateImagePool() async {
    _availableImages
      ..clear()
      ..addAll(_moviePosters);
    await _saveState();
  }

  Future<void> _generateAvatarPool() async {
    _availableAvatars.clear();

    for (int i = 0; i < _avatarPoolSize; i++) {
      final seed = DateTime.now().millisecondsSinceEpoch + i + 10000;
      final url = 'https://picsum.photos/seed/avatar$seed/400/400';
      _availableAvatars.add(url);
    }

    await _saveState();
  }

  Future<void> preloadImagePool() async {
    await initialize();

    for (final url in _availableImages) {
      try {
        await _cacheManager.downloadFile(url);
        LoggerService.debug('Предзагружен постер фильма: $url');
      } catch (_) {
        // ignore
      }
    }
  }

  Future<String?> getNextMovieImage() async {
    await initialize();

    if (_availableImages.isEmpty) {
      await _generateImagePool();
    }

    final imageUrl = _availableImages.removeAt(0);
    _usedImages.add(imageUrl);
    await _saveState();
    return imageUrl;
  }

  Future<String?> getNextAvatar() async {
    await initialize();

    if (_availableAvatars.isEmpty) {
      await _generateAvatarPool();
    }

    final avatarUrl = _availableAvatars.removeAt(0);
    _usedAvatars.add(avatarUrl);
    await _saveState();
    return avatarUrl;
  }

  Future<void> releaseImage(String imageUrl) async {
    await initialize();
    if (_usedImages.remove(imageUrl)) {
      _availableImages.add(imageUrl);
      await _saveState();
    }
  }

  Future<void> releaseAvatar(String avatarUrl) async {
    await initialize();
    if (_usedAvatars.remove(avatarUrl)) {
      _availableAvatars.add(avatarUrl);
      await _saveState();
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsedImages, jsonEncode(_usedImages.toList()));
    await prefs.setString(_keyAvailableImages, jsonEncode(_availableImages));
    await prefs.setString(_keyUsedAvatars, jsonEncode(_usedAvatars.toList()));
    await prefs.setString(_keyAvailableAvatars, jsonEncode(_availableAvatars));
  }

  String getRandomMovieImageUrl(String movieId) {
    final index = movieId.hashCode.abs() % _moviePosters.length;
    return _moviePosters[index];
  }
}
