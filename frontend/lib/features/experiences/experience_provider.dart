import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';
import 'experience.dart';

final experiencesProvider = FutureProvider<List<Experience>>((ref) async {
  final response = await apiClient.get<List<dynamic>>('experiences/');
  return (response.data ?? [])
      .map((item) => Experience.fromJson(item as Map<String, dynamic>))
      .toList();
});
