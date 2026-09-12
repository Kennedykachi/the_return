import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'experience_provider.dart';

class ExperienceListScreen extends ConsumerStatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  ConsumerState<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends ConsumerState<ExperienceListScreen> {
  static const _categories = <({String label, String? value})>[
    (label: 'All', value: null),
    (label: 'History', value: 'history'),
    (label: 'Nature', value: 'nature'),
    (label: 'Culture', value: 'culture'),
    (label: 'Rest', value: 'rest'),
  ];

  String? _selectedCategory;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Discover Ghana'),
          actions: [
            IconButton(onPressed: () => showSearch(context: context, delegate: ExperienceSearch()), icon: const Icon(Icons.search)),
            IconButton(onPressed: () => context.go('/map'), icon: const Icon(Icons.map_outlined)),
          ],
        ),
        body: Column(
          children: [
            _CategoryTabs(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onSelected: (category) => setState(() => _selectedCategory = category),
            ),
            Expanded(
              child: ref.watch(experiencesProvider(_selectedCategory)).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Could not load experiences.\n$error', textAlign: TextAlign.center),
                  ),
                ),
                data: (experiences) {
                  if (experiences.isEmpty) {
                    return const Center(child: Text('No experiences found in this category yet.'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                            trailing: Text(_categoryLabel(experience.category)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/trip'),
          icon: const Icon(Icons.luggage),
          label: const Text('My trip'),
        ),
      );
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<({String label, String? value})> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 56,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            final category = categories[index];
            return ChoiceChip(
              label: Text(category.label),
              selected: selectedCategory == category.value,
              onSelected: (_) => onSelected(category.value),
            );
          },
        ),
      );

String _categoryLabel(String category) {
  if (category.isEmpty) return category;
  return '${category[0].toUpperCase()}${category.substring(1)}';
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
    final experiences = ref.watch(experiencesProvider(null));
    return experiences.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Search is unavailable right now.')),
      data: (items) {
        final normalizedQuery = query.trim().toLowerCase();
        final matches = items.where((item) {
          return normalizedQuery.isEmpty ||
              item.title.toLowerCase().contains(normalizedQuery) ||
              item.category.contains(normalizedQuery) ||
              item.region.toLowerCase().contains(normalizedQuery);
        }).toList();
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(showTrending ? 'Trending now' : 'Results', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...matches.map((item) => ListTile(
                  title: Text(item.title),
                  subtitle: Text('${_categoryLabel(item.category)} · ${item.region}'),
                  onTap: () => context.go('/experiences/${item.slug}'),
                )),
          ],
        );
      },
    );
  }
}
