import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/experiences/experience_list_screen.dart';
import '../features/experiences/experience_detail_screen.dart';
import '../features/map/map_screen.dart';
import '../features/audio/audio_player_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/trips/trip_dashboard_screen.dart';
import '../shared/app_theme.dart';

class ExperienceGhanaApp extends StatelessWidget {
  const ExperienceGhanaApp({super.key});

  static final _router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/experiences', builder: (_, __) => const ExperienceListScreen()),
      GoRoute(
        path: '/experiences/:slug',
        builder: (_, state) => ExperienceDetailScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(path: '/map', builder: (_, __) => const MapScreen()),
      GoRoute(path: '/trip', builder: (_, __) => const TripDashboardScreen()),
      GoRoute(path: '/audio/:slug', builder: (_, state) => AudioPlayerScreen(slug: state.pathParameters['slug']!)),
    ],
  );

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Experience Ghana',
        theme: buildAppTheme(),
        routerConfig: _router,
      );
}
