// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastActivity _$LastActivityFromJson(Map<String, dynamic> json) => LastActivity(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  activity: json['activity'] as String,
  chapterId: (json['chapter_id'] as num?)?.toInt(),
  verseId: (json['verse_id'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$LastActivityToJson(LastActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'activity': instance.activity,
      'chapter_id': instance.chapterId,
      'verse_id': instance.verseId,
      'created_at': instance.createdAt.toIso8601String(),
    };

StreakDay _$StreakDayFromJson(Map<String, dynamic> json) => StreakDay(
  day: json['day'] as String,
  date: json['date'] as String,
  read: json['read'] as bool,
);

Map<String, dynamic> _$StreakDayToJson(StreakDay instance) => <String, dynamic>{
  'day': instance.day,
  'date': instance.date,
  'read': instance.read,
};

StreakSummary _$StreakSummaryFromJson(Map<String, dynamic> json) =>
    StreakSummary(
      currentStreak: (json['currentStreak'] as num).toInt(),
      last7Days: (json['last7Days'] as List<dynamic>)
          .map((e) => StreakDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StreakSummaryToJson(StreakSummary instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'last7Days': instance.last7Days,
    };

VerseTranslation _$VerseTranslationFromJson(Map<String, dynamic> json) =>
    VerseTranslation(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      authorId: (json['author_id'] as num).toInt(),
      authorName: json['author_name'] as String,
      lang: json['lang'] as String?,
      languageId: (json['language_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VerseTranslationToJson(VerseTranslation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'lang': instance.lang,
      'language_id': instance.languageId,
    };

VerseCommentary _$VerseCommentaryFromJson(Map<String, dynamic> json) =>
    VerseCommentary(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      authorId: (json['author_id'] as num).toInt(),
      authorName: json['author_name'] as String,
      lang: json['lang'] as String?,
      languageId: (json['language_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VerseCommentaryToJson(VerseCommentary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'lang': instance.lang,
      'language_id': instance.languageId,
    };

VerseOfTheDay _$VerseOfTheDayFromJson(Map<String, dynamic> json) =>
    VerseOfTheDay(
      id: (json['id'] as num).toInt(),
      chapterId: (json['chapter_id'] as num).toInt(),
      verseNumber: (json['verse_number'] as num).toInt(),
      text: json['text'] as String,
      transliteration: json['transliteration'] as String,
      wordMeanings: json['word_meanings'] as String,
      verseTranslation: (json['verse_translation'] as List<dynamic>?)
          ?.map((e) => VerseTranslation.fromJson(e as Map<String, dynamic>))
          .toList(),
      verseCommentary: (json['commentaries'] as List<dynamic>?)
          ?.map((e) => VerseCommentary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VerseOfTheDayToJson(VerseOfTheDay instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapter_id': instance.chapterId,
      'verse_number': instance.verseNumber,
      'text': instance.text,
      'transliteration': instance.transliteration,
      'word_meanings': instance.wordMeanings,
      'verse_translation': instance.verseTranslation,
      'commentaries': instance.verseCommentary,
    };
