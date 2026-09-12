import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'experience_provider.dart';

class ExperienceListScreen extends ConsumerWidget {
  const ExperienceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: const Text('Discover Ghana'),
          actions: [
            IconButton(onPressed: () => showSearch(context: context, delegate: ExperienceSearch()), icon: const Icon(Icons.search)),
            IconButton(onPressed: () => context.go('/map'), icon: const Icon(Icons.map_outlined)),
          ],
        ),
        body: ref.watch(experiencesProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load experiences.\n$error', textAlign: TextAlign.center),
          )),
          data: (experiences) => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: experiences.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final experience = experiences[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.go('/experiences/${experience.slug}'),
                  child: ListTile(
                    leading: Image.network(experience.imageUrl, width: 64, height: 64, fit: BoxFit.cover),
                    title: Text(experience.title),
                    subtitle: Text('${experience.region} · ${experience.timeCommitment}'),
                    trailing: Text(experience.category),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/trip'),
          icon: const Icon(Icons.luggage),
          label: const Text('My trip'),
        ),
      );
}

class ExperienceSearch extends SearchDelegate<void> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) => _SearchResults(query: query);

  @override
  Widget buildSuggestions(BuildContext context) => _SearchResults(query: query, showTrending: query.isEmpty);
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query, this.showTrending = false});
  final String query;
  final bool showTrending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiences = ref.watch(experiencesProvider);
    return experiences.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Search is unavailable right now.')),
      data: (items) {
        final matches = items.where((item) => item.title.toLowerCase().contains(query.toLowerCase()) || item.category.contains(query.toLowerCase())).toList();
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(showTrending ? 'Trending now' : 'Results', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...matches.map((item) => ListTile(
              title: Text(item.title),
              subtitle: Text('${item.category} · ${item.region}'),
              onTap: () => context.go('/experiences/${item.slug}'),
            )),
          ],
        );
      },
    );
  }
}
