import 'package:app/core/network/dio_provider.dart';
import 'package:app/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'bookmarks_repository.g.dart';

@riverpod
BookmarksRepository bookmarksRepository(Ref ref) {
  return BookmarksRepository(ref.watch(dioProvider));
}

class BookmarksRepository {
  BookmarksRepository(this._dio);
  final Dio _dio;

  Future<Set<int>> getFavorites() async {
    try {
      final response = await _dio.get(ApiEndpoints.favoriteList);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final list = response.data['favorites'] as List;
        return list.map((e) => e['verse_id'] as int).toSet();
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<List<dynamic>> getFavoriteDetails() async {
    try {
      final response = await _dio.get(ApiEndpoints.favoriteList);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        return response.data['favorites'] as List;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> addFavorite(int verseId) async {
    try {
      final response = await _dio.post(ApiEndpoints.favoriteAdd, data: {
        'verse_id': verseId,
      });
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFavorite(int verseId) async {
    try {
      final response = await _dio.delete(ApiEndpoints.favoriteRemove, data: {
        'verse_id': verseId,
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
