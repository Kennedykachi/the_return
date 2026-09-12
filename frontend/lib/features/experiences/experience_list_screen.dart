import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'experience.dart';
import 'experience_provider.dart';
import 'search_history_store.dart';

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
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value.trim().toLowerCase()),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search places, regions, or categories',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          icon: const Icon(Icons.clear),
                        ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
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
                  final filtered = experiences.where(_matchesSearch).toList();
                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        experiences.isEmpty
                            ? 'No experiences found in this category yet.'
                            : 'No experiences match your search.',
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final experience = filtered[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => context.go('/experiences/${experience.slug}'),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    experience.imageUrl,
                                    width: 92,
                                    height: 92,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const ColoredBox(
                                      color: Colors.black12,
                                      child: SizedBox(width: 92, height: 92, child: Icon(Icons.image_not_supported_outlined)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              experience.title,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          _TierBadge(tier: experience.tier),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text('${_categoryLabel(experience.category)} · ${experience.region}'),
                                      const SizedBox(height: 4),
                                      Text(
                                        experience.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: 6),
                                      Text('${experience.timeCommitment} · ${experience.physicalLevel}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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

  bool _matchesSearch(Experience experience) {
    return _searchQuery.isEmpty ||
        experience.title.toLowerCase().contains(_searchQuery) ||
        experience.category.toLowerCase().contains(_searchQuery) ||
        experience.region.toLowerCase().contains(_searchQuery) ||
        experience.address.toLowerCase().contains(_searchQuery);
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.tier});

  final String tier;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            _tierLabel(tier),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      );
}

String _tierLabel(String tier) {
  switch (tier) {
    case 'hidden_gem':
      return 'Hidden gem';
    case 'signature':
      return 'Signature';
    case 'featured':
      return 'Featured';
    default:
      return tier;
  }
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
}

String _categoryLabel(String category) {
  if (category.isEmpty) return category;
  return '${category[0].toUpperCase()}${category.substring(1)}';
}

class ExperienceSearch extends SearchDelegate<void> {
  ExperienceSearch() : _historyStore = SearchHistoryStore();

  final SearchHistoryStore _historyStore;
  String? _selectedCategory;

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
  void showResults(BuildContext context) {
    _saveQuery();
    super.showResults(context);
  }

  void _saveQuery() {
    if (query.trim().isNotEmpty) _historyStore.add(query);
  }

  @override
  Widget buildResults(BuildContext context) => _SearchResults(
        query: query,
        category: _selectedCategory,
        showTrending: false,
        historyStore: _historyStore,
        onRecentSearch: (value) {
          query = value;
          showResults(context);
        },
        onCategoryChanged: (value) {
          _selectedCategory = value;
          showSuggestions(context);
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) => _SearchResults(
        query: query,
        category: _selectedCategory,
        showTrending: query.trim().isEmpty,
        historyStore: _historyStore,
        onRecentSearch: (value) {
          query = value;
          showResults(context);
        },
        onCategoryChanged: (value) {
          _selectedCategory = value;
          showSuggestions(context);
        },
      );

}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({
    required this.query,
    required this.historyStore,
    required this.onCategoryChanged,
    required this.onRecentSearch,
    this.category,
    this.showTrending = false,
  });
  final String query;
  final String? category;
  final bool showTrending;
  final SearchHistoryStore historyStore;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String> onRecentSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiences = ref.watch(experiencesProvider(null));
    return experiences.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Search is unavailable right now.')),
      data: (items) {
        final normalizedQuery = query.trim().toLowerCase();
        final matches = items.where((item) {
          final matchesCategory = category == null || item.category == category;
          return matchesCategory &&
              (normalizedQuery.isEmpty ||
              item.title.toLowerCase().contains(normalizedQuery) ||
              item.category.contains(normalizedQuery) ||
              item.region.toLowerCase().contains(normalizedQuery) ||
              item.address.toLowerCase().contains(normalizedQuery));
        }).toList();
        final visible = showTrending
            ? (matches.where((item) => item.tier == 'signature' || item.tier == 'featured').take(3).toList())
            : matches;
        return Column(
          children: [
            _SearchCategoryFilters(
              category: category,
              onSelected: onCategoryChanged,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                children: [
                  if (showTrending) ...[
                    Text('Trending now', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                  ] else if (normalizedQuery.isNotEmpty) ...[
                    Text('${visible.length} result${visible.length == 1 ? '' : 's'}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                  ],
                  if (visible.isEmpty)
                    Text(showTrending ? 'No trending experiences yet.' : 'No experiences match your search.')
                  else
                    ...visible.map((item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.title),
                          subtitle: Text('${_categoryLabel(item.category)} · ${item.region}'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => context.go('/experiences/${item.slug}'),
                        )),
                  if (showTrending)
                    FutureBuilder<List<String>>(
                      future: historyStore.read(),
                      builder: (_, snapshot) {
                        final searches = snapshot.data ?? const <String>[];
                        if (searches.isEmpty) return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Recent searches', style: Theme.of(context).textTheme.titleMedium),
                                TextButton(
                                  onPressed: () async {
                                    await historyStore.clear();
                                    (context as Element).markNeedsBuild();
                                  },
                                  child: const Text('Clear'),
                                ),
                              ],
                            ),
                            ...searches.map((search) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.history),
                                  title: Text(search),
                                  onTap: () => onRecentSearch(search),
                                )),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SearchCategoryFilters extends StatelessWidget {
  const _SearchCategoryFilters({required this.category, required this.onSelected});

  static const _categories = <({String label, String? value})>[
    (label: 'All', value: null),
    (label: 'History', value: 'history'),
    (label: 'Nature', value: 'nature'),
    (label: 'Culture', value: 'culture'),
    (label: 'Rest', value: 'rest'),
  ];

  final String? category;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 56,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            final item = _categories[index];
            return ChoiceChip(
              label: Text(item.label),
              selected: category == item.value,
              onSelected: (_) => onSelected(item.value),
            );
          },
        ),
      );
}
