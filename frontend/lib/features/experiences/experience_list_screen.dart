import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExperienceListScreen extends StatelessWidget {
  const ExperienceListScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Discover Ghana'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        ),
        body: const Center(
          child: Text('Experience discovery, search, and map views are ready for API integration.'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/trip'),
          icon: const Icon(Icons.luggage),
          label: const Text('My trip'),
        ),
      );
}
