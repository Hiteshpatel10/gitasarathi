import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A generic, versioned, key-value cache backed by SharedPreferences.
///
/// Stores any JSON-serializable data alongside a timestamp and a server-provided
/// version number. Invalidation is driven by the server (via cache_config in the
/// Profile API) rather than arbitrary TTLs.
///
/// Usage:
///   final cache = ref.read(cacheServiceProvider);
///   await cache.put(CacheKeys.verseOfTheDay, json, version: 42);
///   final entry = await cache.get(CacheKeys.verseOfTheDay, version: currentVersion);
class CacheValidator {
  final String key;
  final int version;
  final int? autoClearFreq; // in milliseconds

  CacheValidator({required this.key, required this.version, this.autoClearFreq});

  factory CacheValidator.fromJson(Map<String, dynamic> json) {
    return CacheValidator(
      key: json['key'] as String,
      version: json['version'] as int,
      autoClearFreq: json['auto_clear_freq'] as int?,
    );
  }
}

class CacheService {
  CacheService(this._prefs);
  final SharedPreferences _prefs;

  static const _prefix = 'cache:';
  static const _metaSuffix = ':meta';

  // ── Key factory constants ─────────────────────────────────────────────────

  static String verseOfTheDay() => '${_prefix}verse_of_the_day';
  static String verse(int id) => '${_prefix}verse:$id';
  static String chapterList() => '${_prefix}chapter_list';
  static String verseList(int chapterId) => '${_prefix}verses:$chapterId';
  static String verseExplanation(int verseId) => '${_prefix}verseExplanation:$verseId';
  static String authorCatalog() => '${_prefix}author_catalog';

  // ── Write ─────────────────────────────────────────────────────────────────

  /// Stores [json] under [key]. Pass [version] from the server's cache_config.
  Future<void> put(String key, Map<String, dynamic> json, {int version = 0}) async {
    final meta = {
      'cached_at': DateTime.now().toIso8601String(),
      'version': version,
    };
    await _prefs.setString(key, jsonEncode(json));
    await _prefs.setString('$key$_metaSuffix', jsonEncode(meta));
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  /// Returns cached JSON if present.
  /// Freshness is managed by runCacheValidatorList instead of per-call checks.
  Future<Map<String, dynamic>?> get(String key) async {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  // ── Version check & Invalidation ─────────────────────────────────────────

  /// Given a list of [CacheValidator] from the backend, compares their versions
  /// with the stored versions, and checks autoClearFreq if provided. 
  /// If the backend version is newer (greater) or the cache has expired,
  /// the cache for that key is invalidated.
  Future<List<String>> runCacheValidatorList(List<CacheValidator> validators) async {
    final invalidatedKeys = <String>[];

    for (final validator in validators) {
      final storedVersion = _storedVersion(validator.key);
      final cachedAt = _cachedAt(validator.key);

      bool shouldInvalidate = false;

      if (storedVersion != -1 && validator.version > storedVersion) {
        // Backend has a newer version, or version changed
        shouldInvalidate = true;
      } else if (cachedAt != null && validator.autoClearFreq != null) {
        // Check time-based expiration (autoClearFreq in milliseconds)
        final ageMs = DateTime.now().difference(cachedAt).inMilliseconds;
        if (ageMs > validator.autoClearFreq!) {
          shouldInvalidate = true;
        }
      }

      if (shouldInvalidate) {
        await invalidate(validator.key);
        invalidatedKeys.add(validator.key);
      }
    }

    return invalidatedKeys;
  }

  int _storedVersion(String key) {
    final metaRaw = _prefs.getString('$key$_metaSuffix');
    if (metaRaw == null) return -1;
    final meta = jsonDecode(metaRaw) as Map<String, dynamic>;
    return meta['version'] as int? ?? -1;
  }

  DateTime? _cachedAt(String key) {
    final metaRaw = _prefs.getString('$key$_metaSuffix');
    if (metaRaw == null) return null;
    final meta = jsonDecode(metaRaw) as Map<String, dynamic>;
    final dateStr = meta['cached_at'] as String?;
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  // ── Invalidation ─────────────────────────────────────────────────────────

  Future<void> invalidate(String key) async {
    await _prefs.remove(key);
    await _prefs.remove('$key$_metaSuffix');
  }

  Future<void> clearAll() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}

/// Riverpod provider — reads SharedPreferences directly (always fresh).
final cacheServiceProvider = Provider<CacheService>((ref) {
  throw UnimplementedError('cacheServiceProvider must be overridden in main.dart');
});
