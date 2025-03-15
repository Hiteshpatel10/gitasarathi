part of 'chapters_and_verse_cubit.dart';

@immutable
sealed class ChaptersAndVerseState {}

final class ChapterInitial extends ChaptersAndVerseState {}

class LoadingState extends ChaptersAndVerseState {}

class ErrorState extends ChaptersAndVerseState {}

class ChapterAndVerseSuccessState extends ChaptersAndVerseState {
  ChapterAndVerseSuccessState({required this.chaptersAndVerse});
  final ChaptersAndVerseModel chaptersAndVerse;
}
