import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/services/logger_service.dart';
import 'package:app/core/network/dio_provider.dart';
import '../repository/auth_repository.dart';

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final logger = ref.watch(loggerProvider);
  final dio = ref.watch(dioProvider);
  return AuthRepository(logger: logger, dio: dio);
});
