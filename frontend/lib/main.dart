import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  const mapboxToken = String.fromEnvironment('ACCESS_TOKEN');
  if (mapboxToken.isNotEmpty) MapboxOptions.setAccessToken(mapboxToken);
  runApp(const ProviderScope(child: ExperienceGhanaApp()));
}
