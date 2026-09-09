import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final interests = ['History', 'Nature', 'Culture', 'Rest'];
  final selected = <String>{};

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text('EXPERIENCE GHANA', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.terracotta, letterSpacing: 1.6)),
                const SizedBox(height: 12),
                Text('What draws you to Ghana?', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.deepIndigo, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                const Text('Explore Ghana. Deeply'),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: interests.map((interest) => FilterChip(
                    label: Text(interest),
                    selected: selected.contains(interest),
                    onSelected: (value) => setState(() => value ? selected.add(interest) : selected.remove(interest)),
                  )).toList(),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: selected.isEmpty ? null : () => context.go('/experiences'),
                    child: const Text('Start exploring'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
