import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api_client.dart';

final experienceDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, slug) async {
  final response = await apiClient.get<Map<String, dynamic>>('experiences/$slug/');
  return response.data!;
});

class ExperienceDetailScreen extends ConsumerWidget {
  const ExperienceDetailScreen({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: ref.watch(experienceDetailProvider(slug)).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Could not load this experience.\n$error')),
          data: (experience) => CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 310,
                pinned: true,
                actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border))],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(fit: StackFit.expand, children: [
                    Image.network(experience['image_url'] as String, fit: BoxFit.cover),
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: Chip(label: Text((experience['category'] as String).toUpperCase())),
                    ),
                  ]),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(experience['title'] as String, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 6),
                    Text(experience['region'] as String, style: Theme.of(context).textTheme.titleMedium),
                    if ((experience['audio_url'] as String).isNotEmpty) ...[
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () => context.go('/audio/$slug'),
                        icon: const Icon(Icons.headphones),
                        label: const Text('Listen to a 30-sec preview'),
                      ),
                    ],
                    const SizedBox(height: 24),
                    _Stats(experience: experience),
                    const SizedBox(height: 28),
                    Text('The soul', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(experience['description'] as String),
                    const SizedBox(height: 28),
                    Text('What you’ll experience', style: Theme.of(context).textTheme.titleLarge),
                    ...((experience['bullet_points'] as List<dynamic>).map((point) => ListTile(leading: const Icon(Icons.check_circle_outline), contentPadding: EdgeInsets.zero, title: Text(point as String)))),
                    const SizedBox(height: 18),
                    _Logistics(experience: experience),
                    const SizedBox(height: 24),
                    Text('Experience this with…', style: Theme.of(context).textTheme.titleLarge),
                    ...((experience['related_experiences'] as List<dynamic>).map((related) {
                      final item = related as Map<String, dynamic>;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(item['image_url'] as String, width: 52, height: 52, fit: BoxFit.cover),
                        ),
                        title: Text(item['title'] as String),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => context.go('/experiences/${item['slug']}'),
                      );
                    })),
                  ]),
                ),
              ),
            ],
          ),
        ),
      );
}

class _Stats extends StatelessWidget {
  const _Stats({required this.experience});
  final Map<String, dynamic> experience;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _Stat(icon: Icons.schedule, label: experience['time_commitment'] as String),
          _Stat(icon: Icons.directions_walk, label: experience['physical_level'] as String),
          _Stat(icon: Icons.confirmation_number_outlined, label: experience['entry_fee_foreigner'] as String),
        ]),
      );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Chip(avatar: Icon(icon, size: 18), label: Text(label)),
      );
}

class _Logistics extends StatelessWidget {
  const _Logistics({required this.experience});
  final Map<String, dynamic> experience;
  @override
  Widget build(BuildContext context) => ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text('Plan your visit', style: Theme.of(context).textTheme.titleLarge),
        children: [
          _Fact(label: 'Hours', value: experience['opening_hours'] as String),
          _Fact(label: 'Best time', value: experience['best_time_to_visit'] as String),
          _Fact(label: 'Bring', value: experience['what_to_bring'] as String),
          _Fact(label: 'Getting there', value: experience['getting_there'] as String),
        ],
      );
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: EdgeInsets.zero, title: Text(label), subtitle: Text(value));
}
