import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'query_cache.dart';

class QueryClient {
  final SharedPreferences storage;
  final Map<String, QueryCache<dynamic>> _cache = {};

  QueryClient({required this.storage});

  QueryCache<T> getOrCreate<T>(
    String key, {
    Duration ttl = const Duration(minutes: 5),
  }) {
    if (!_cache.containsKey(key)) {
      _cache[key] = QueryCache<T>(
        ttl: ttl,
        onUpdate: (data) => _persist<T>(key, data),
      );
      _load<T>(key); // Load from local storage
    }
    return _cache[key] as QueryCache<T>;
  }

  void invalidate(String key) {
    _cache.remove(key);
    storage.remove('query_$key');
  }

  void clearAll() {
    _cache.clear();
    storage.clear();
  }

  bool isCached(String key) => _cache.containsKey(key);

  Future<void> _persist<T>(String key, T data) async {
    try {
      final json = jsonEncode(data); // ensure JSON-serializable
      await storage.setString('query_$key', json);
    } catch (_) {
      // Ignore non-serializable data
    }
  }

  Future<void> _load<T>(String key) async {
    final raw = storage.getString('query_$key');
    if (raw == null) return;

    try {
      final decoded = jsonDecode(raw);
      final cache = _cache[key] as QueryCache<T>?;
      if (cache != null) {
        cache.setData(decoded as T, isFromStorage: true);
      }
    } catch (_) {
      // Ignore corrupted or invalid JSON
    }
  }
}
