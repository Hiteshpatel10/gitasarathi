import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class AudioCacheService {
  AudioCacheService._();
  static final AudioCacheService instance = AudioCacheService._();

  final Dio _dio = Dio();
  final Map<String, Future<String?>> _inFlight = {};

  /// Returns the local file path for [url], downloading if not cached.
  Future<String?> getLocalPath(String url) async {
    if (url.isEmpty) return null;
    if (_inFlight.containsKey(url)) return _inFlight[url];

    final future = _resolveLocalPath(url);
    _inFlight[url] = future;
    try {
      return await future;
    } finally {
      _inFlight.remove(url);
    }
  }

  Future<String?> _resolveLocalPath(String url) async {
    try {
      final cacheDir = await _getCacheDir();
      final filename = _cacheKey(url);
      final file = File('${cacheDir.path}/$filename.mp3');

      if (await file.exists()) return file.path;

      final tempFile = File('${cacheDir.path}/$filename.tmp');
      await _dio.download(url, tempFile.path);
      await tempFile.rename(file.path);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  /// Fire-and-forget prefetch — warms the cache in the background.
  void prefetch(String? url) {
    if (url == null || url.isEmpty) return;
    getLocalPath(url);
  }

  Future<Directory> _getCacheDir() async {
    final base = await getApplicationCacheDirectory();
    final dir = Directory('${base.path}/audio');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  String _cacheKey(String url) =>
      md5.convert(utf8.encode(url)).toString();
}
