import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/experiences/experience_list_screen.dart';
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
      GoRoute(path: '/trip', builder: (_, __) => const TripDashboardScreen()),
    ],
  );

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Experience Ghana',
        theme: buildAppTheme(),
        routerConfig: _router,
      );
}
