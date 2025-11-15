import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_9/shared/app_theme.dart';
import 'package:practice_9/features/books/bloc/movies_bloc.dart';
import 'package:practice_9/features/books/bloc/movies_event.dart';
import 'package:practice_9/features/auth/bloc/auth_bloc.dart';
import 'package:practice_9/features/auth/bloc/auth_event.dart';
import 'package:practice_9/features/auth/bloc/auth_state.dart';
import 'package:practice_9/features/profile/bloc/profile_cubit.dart';
import 'package:practice_9/features/theme/bloc/theme_cubit.dart';
import 'package:practice_9/features/theme/bloc/theme_state.dart';
import 'package:practice_9/core/router/app_router.dart';
import 'package:practice_9/core/di/service_locator.dart';

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authService: Services.auth,
          )..add(const CheckAccount()),
        ),
        BlocProvider(
          create: (context) => MoviesBloc(
            repository: Repositories.movies,
          )..add(const LoadMovies()),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(
            profileService: Services.profile,
          )..loadProfile(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit()..loadTheme(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final themeMode = themeState is ThemeLoaded
              ? themeState.themeMode
              : ThemeMode.light;

          return BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is AuthLogin || authState is AuthRegister) {

                AppRouter.router.go('/auth');
              } else if (authState is Authenticated) {

                AppRouter.router.go('/');
              }
            },
            child: MaterialApp.router(
              title: 'Моя фильмотека',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}
