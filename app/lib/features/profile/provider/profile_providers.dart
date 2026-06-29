import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/profile_repository.dart';

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getUserProfile();
});

final userProgressProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getUserProgress();
});
