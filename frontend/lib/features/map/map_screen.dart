import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../experiences/experience_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  bool isMapView = true;
  double radius = 40;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Explore nearby')),
        body: Stack(children: [
          Positioned.fill(
            child: isMapView
                ? const _ExperienceMap()
                : ref.watch(experiencesProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Could not load places.')),
                  data: (items) => ListView(children: items.map((item) => ListTile(title: Text(item.title), subtitle: Text(item.region))).toList()),
                ),
          ),
          Positioned(
            top: 16, left: 16, right: 16,
            child: Card(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(children: [
                ChoiceChip(label: const Text('Map'), selected: isMapView, onSelected: (_) => setState(() => isMapView = true)),
                const SizedBox(width: 8),
                ChoiceChip(label: const Text('List'), selected: !isMapView, onSelected: (_) => setState(() => isMapView = false)),
              ]),
            )),
          ),
          Positioned(
            bottom: 24, left: 24, right: 24,
            child: Card(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Within ${radius.round()} km'),
                Slider(value: radius, min: 5, max: 150, divisions: 29, onChanged: (value) => setState(() => radius = value)),
              ]),
            )),
          ),
        ]),
      );
}

class _ExperienceMap extends ConsumerStatefulWidget {
  const _ExperienceMap();

  @override
  ConsumerState<_ExperienceMap> createState() => _ExperienceMapState();
}

class _ExperienceMapState extends ConsumerState<_ExperienceMap> {
  static const _token = String.fromEnvironment('ACCESS_TOKEN');

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    final experiences = await ref.read(experiencesProvider.future);
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();
    for (final experience in experiences) {
      await manager.create(CircleAnnotationOptions(
        geometry: Point(coordinates: Position(experience.longitude, experience.latitude)),
        circleRadius: 9,
        circleColor: '#C04A35',
        circleStrokeColor: '#1A2A44',
        circleStrokeWidth: 2,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_token.isEmpty) return const _MapTokenNotice();
    return MapWidget(
      key: const ValueKey('experience-map'),
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(-1.15, 6.15)),
        zoom: 6.3,
      ),
      onMapCreated: _onMapCreated,
    );
  }
}

class _MapTokenNotice extends StatelessWidget {
  const _MapTokenNotice();
  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.map_outlined, size: 64), SizedBox(height: 12), Text('Run with ACCESS_TOKEN to render the live Mapbox map.'),
        ])),
      );
}
