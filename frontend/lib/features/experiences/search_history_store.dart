import 'package:hive_flutter/hive_flutter.dart';

class SearchHistoryStore {
  static const _boxName = 'search_history';
  static const _maxItems = 8;

  Future<List<String>> read() async {
    final box = await Hive.openBox<String>(_boxName);
    return box.values.toList().reversed.toList();
  }

  Future<void> add(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return;

    final box = await Hive.openBox<String>(_boxName);
    final existing = box.values.where((value) => value.toLowerCase() != normalized.toLowerCase()).toList();
    await box.clear();
    final values = [...existing, normalized].take(_maxItems).toList();
    for (var index = 0; index < values.length; index++) {
      await box.put(index, values[index]);
    }
  }

  Future<void> clear() async {
    final box = await Hive.openBox<String>(_boxName);
    await box.clear();
  }
}
