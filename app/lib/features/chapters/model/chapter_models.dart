import 'package:json_annotation/json_annotation.dart';

part 'chapter_models.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Chapter {
  Chapter({
    required this.id,
    required this.chapterNumber,
    required this.chapterSummary,
    required this.chapterSummaryHindi,
    required this.imageName,
    required this.imageUrl,
    required this.name,
    required this.nameMeaning,
    required this.nameTranslation,
    required this.nameTransliterated,
    required this.versesCount,
    this.progress,
    this.listenProgress,
    this.readVerses,
  });

  final int id;
  final int chapterNumber;
  final String chapterSummary;
  final String chapterSummaryHindi;
  final String imageName;
  final String imageUrl;
  final String name;
  final String nameMeaning;
  final String nameTranslation;
  final String nameTransliterated;
  final int versesCount;
  final double? progress;
  final double? listenProgress;
  final List<int>? readVerses;

  Chapter copyWith({
    int? id,
    int? chapterNumber,
    String? chapterSummary,
    String? chapterSummaryHindi,
    String? imageName,
    String? imageUrl,
    String? name,
    String? nameMeaning,
    String? nameTranslation,
    String? nameTransliterated,
    int? versesCount,
    double? progress,
    double? listenProgress,
    List<int>? readVerses,
  }) {
    return Chapter(
      id: id ?? this.id,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      chapterSummary: chapterSummary ?? this.chapterSummary,
      chapterSummaryHindi: chapterSummaryHindi ?? this.chapterSummaryHindi,
      imageName: imageName ?? this.imageName,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      nameMeaning: nameMeaning ?? this.nameMeaning,
      nameTranslation: nameTranslation ?? this.nameTranslation,
      nameTransliterated: nameTransliterated ?? this.nameTransliterated,
      versesCount: versesCount ?? this.versesCount,
      progress: progress ?? this.progress,
      listenProgress: listenProgress ?? this.listenProgress,
      readVerses: readVerses ?? this.readVerses,
    );
  }

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}

class VerseMetadata {
  VerseMetadata({
    required this.id,
    required this.chapterId,
    required this.verseNumber,
  });

  final int id;
  final int chapterId;
  final int verseNumber;

  factory VerseMetadata.fromJson(Map<String, dynamic> json) {
    return VerseMetadata(
      id: json['id'] as int,
      chapterId: json['chapter_id'] as int,
      verseNumber: json['verse_number'] as int,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserProgressData {
  UserProgressData({
    required this.reads,
    required this.listens,
  });

  @JsonKey(defaultValue: [])
  final List<ChapterProgress> reads;
  
  @JsonKey(defaultValue: [])
  final List<ChapterProgress> listens;

  factory UserProgressData.fromJson(Map<String, dynamic> json) => _$UserProgressDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserProgressDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChapterProgress {
  ChapterProgress({
    required this.chapter,
    required this.progress,
    this.verses,
  });

  final int chapter;
  final double progress;
  final String? verses;

  factory ChapterProgress.fromJson(Map<String, dynamic> json) {
    return ChapterProgress(
      chapter: json['chapter'] as int,
      progress: (json['progress'] as num).toDouble(),
      verses: json['verses'] as String?,
    );
  }
  Map<String, dynamic> toJson() => _$ChapterProgressToJson(this);
}
