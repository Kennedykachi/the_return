import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationLabelProvider = FutureProvider<String>((ref) async {
  if (!await Geolocator.isLocationServiceEnabled()) return 'GPS: location services are off';
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return 'GPS: permission not granted';
  final position = await Geolocator.getCurrentPosition();
  return 'GPS: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
});
