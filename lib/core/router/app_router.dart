import 'package:go_router/go_router.dart';
import 'package:practice_9/core/di/service_locator.dart';
import 'package:practice_9/features/auth/auth_screen.dart';
import 'package:practice_9/features/books/screens/home_screen.dart';
import 'package:practice_9/features/books/screens/watched_movies_screen.dart';
import 'package:practice_9/features/books/screens/watchlist_screen.dart';
import 'package:practice_9/features/books/screens/all_movies_screen.dart';
import 'package:practice_9/features/books/screens/movie_detail_screen.dart';
import 'package:practice_9/features/books/screens/movie_form_screen.dart';
import 'package:practice_9/features/books/screens/my_collection_screen.dart';
import 'package:practice_9/features/books/screens/ratings_screen.dart';
import 'package:practice_9/features/books/screens/statistics_screen.dart';
import 'package:practice_9/features/profile/profile_screen.dart';
import 'package:practice_9/features/books/models/movie.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isLoggedIn = await Services.auth.isLoggedIn();
      final isGoingToAuth = state.matchedLocation == '/auth';

      if (!isLoggedIn && !isGoingToAuth) {
        return '/auth';
      }

      if (isLoggedIn && isGoingToAuth) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/watched-movies',
        name: 'watched-movies',
        builder: (context, state) => const WatchedMoviesScreen(),
      ),
      GoRoute(
        path: '/watchlist',
        name: 'watchlist',
        builder: (context, state) => const WatchlistScreen(),
      ),
      GoRoute(
        path: '/all-movies',
        name: 'all-movies',
        builder: (context, state) => const AllMoviesScreen(),
      ),
      GoRoute(
        path: '/my-collection',
        name: 'my-collection',
        builder: (context, state) => const MovieCollectionScreen(),
      ),
      GoRoute(
        path: '/ratings',
        name: 'ratings',
        builder: (context, state) => const RatingsScreen(),
      ),
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: '/movie/:id',
        name: 'movie-detail',
        builder: (context, state) {
          final movie = state.extra as Movie;
          return MovieDetailScreen(movie: movie);
        },
      ),
      GoRoute(
        path: '/movie-form',
        name: 'movie-form',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>?;
          final onSave = params?['onSave'] as Function(Movie)?;
          final movie = params?['movie'] as Movie?;

          return MovieFormScreen(
            onSave: onSave ?? (movie) {},
            movie: movie,
          );
        },
      ),
    ],
  );
}
