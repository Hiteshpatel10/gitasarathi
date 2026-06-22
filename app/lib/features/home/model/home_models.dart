import 'package:json_annotation/json_annotation.dart';

part 'home_models.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LastActivity {
  LastActivity({
    required this.id,
    required this.userId,
    required this.activity,
    this.chapterId,
    this.verseId,
    required this.createdAt,
  });

  final int id;
  final int userId;
  final String activity;
  final int? chapterId;
  final int? verseId;
  final DateTime createdAt;

  factory LastActivity.fromJson(Map<String, dynamic> json) =>
      _$LastActivityFromJson(json);
  Map<String, dynamic> toJson() => _$LastActivityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StreakDay {
  StreakDay({
    required this.day,
    required this.date,
    required this.read,
  });

  final String day;
  final String date;
  final bool read;

  factory StreakDay.fromJson(Map<String, dynamic> json) =>
      _$StreakDayFromJson(json);
  Map<String, dynamic> toJson() => _$StreakDayToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StreakSummary {
  StreakSummary({
    required this.currentStreak,
    required this.last7Days,
  });

  final int currentStreak;
  final List<StreakDay> last7Days;

  factory StreakSummary.fromJson(Map<String, dynamic> json) =>
      _$StreakSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$StreakSummaryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VerseOfTheDay {
  VerseOfTheDay({
    required this.id,
    required this.chapterId,
    required this.verseNumber,
    required this.text,
    required this.transliteration,
    required this.wordMeanings,
    this.translations,
  });

  final int id;
  final int chapterId;
  final int verseNumber;
  final String text;
  final String transliteration;
  final String wordMeanings;
  final List<VerseTranslation>? translations;

  factory VerseOfTheDay.fromJson(Map<String, dynamic> json) =>
      _$VerseOfTheDayFromJson(json);
  Map<String, dynamic> toJson() => _$VerseOfTheDayToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VerseTranslation {
  VerseTranslation({
    required this.id,
    required this.description,
    required this.authorId,
    required this.languageId,
  });

  final int id;
  final String description;
  final int authorId;
  final int languageId;

  factory VerseTranslation.fromJson(Map<String, dynamic> json) =>
      _$VerseTranslationFromJson(json);
  Map<String, dynamic> toJson() => _$VerseTranslationToJson(this);
}
