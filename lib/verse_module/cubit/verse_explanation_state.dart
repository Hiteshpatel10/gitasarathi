part of 'verse_explanation_cubit.dart';

@immutable
sealed class VerseExplanationState {}

final class VerseExplanationInitial extends VerseExplanationState {}

final class VerseExplanationLoading extends VerseExplanationState {}

final class VerseExplanationSuccess extends VerseExplanationState {
  final VerseExplanationModel verseExplanation;

  VerseExplanationSuccess({required this.verseExplanation});
}

final class VerseExplanationError extends VerseExplanationState {
  final String error;

  VerseExplanationError({required this.error});
}
