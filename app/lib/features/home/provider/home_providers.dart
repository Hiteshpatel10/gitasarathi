import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repository/home_repository.dart';
import '../model/home_models.dart';

part 'home_providers.g.dart';

@riverpod
Future<LastActivity?> lastActivity(Ref ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getLastActivity();
}

@riverpod
Future<StreakSummary?> streakSummary(Ref ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getStreakSummary();
}

@riverpod
Future<VerseOfTheDay?> verseOfTheDay(Ref ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  // Default to English translation (id: 1) for Swami Sivananda or similar
  return repository.getVerseOfTheDay(translationAuthorId: 1, commentaryAuthorId: 1);
}
