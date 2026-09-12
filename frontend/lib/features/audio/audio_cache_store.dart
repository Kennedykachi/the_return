import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class AudioCacheStore {
  AudioCacheStore(this._dio);
  final Dio _dio;
  static const _boxName = 'offline_audio';

  Future<Box<String>> get _box => Hive.openBox<String>(_boxName);

  Future<String?> localPathFor(String url) async {
    final path = (await _box).get(url);
    return path != null && File(path).existsSync() ? path : null;
  }

  Future<void> download(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/experience_${url.hashCode}.mp3';
    await _dio.download(url, path);
    await (await _box).put(url, path);
  }
}
