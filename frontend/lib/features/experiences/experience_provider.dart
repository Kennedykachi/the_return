import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';
import 'experience.dart';

final experiencesProvider = FutureProvider.family<List<Experience>, String?>((ref, category) async {
  final response = await fetchExperiences(category: category);
  return (response.data ?? [])
      .map((item) => Experience.fromJson(item as Map<String, dynamic>))
      .toList();
});
