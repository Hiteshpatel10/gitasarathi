import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_events.g.dart';

@riverpod
class CacheInvalidationEvent extends _$CacheInvalidationEvent {
  @override
  List<String> build() => [];

  void notify(List<String> keys) {
    state = keys;
  }
}
