part of 'language_and_author_cubit.dart';

@immutable
sealed class LanguageAndAuthorState {}

/// Initial State
final class LanguageAndAuthorInitial extends LanguageAndAuthorState {}

/// Loading State (when fetching data)
final class LanguageAndAuthorLoading extends LanguageAndAuthorState {}

/// Loaded State (when data is successfully fetched)
final class LanguageAndAuthorSuccess extends LanguageAndAuthorState {
  final LanguageAndAuthorModel languageAndAuthors;

  LanguageAndAuthorSuccess({required this.languageAndAuthors});
}

/// Error State (when fetching fails)
final class LanguageAndAuthorError extends LanguageAndAuthorState {
  final String message;

  LanguageAndAuthorError({required this.message});
}
