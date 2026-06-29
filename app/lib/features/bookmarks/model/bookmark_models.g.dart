// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkItem _$BookmarkItemFromJson(Map<String, dynamic> json) => BookmarkItem(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  verseId: (json['verse_id'] as num).toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  verse: json['verse'] == null
      ? null
      : BookmarkVerse.fromJson(json['verse'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookmarkItemToJson(BookmarkItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'verse_id': instance.verseId,
      'created_at': instance.createdAt?.toIso8601String(),
      'verse': instance.verse,
    };

BookmarkVerse _$BookmarkVerseFromJson(Map<String, dynamic> json) =>
    BookmarkVerse(
      id: (json['id'] as num).toInt(),
      chapterNumber: (json['chapter_number'] as num).toInt(),
      verseNumber: (json['verse_number'] as num).toInt(),
      text: json['text'] as String?,
      transliteration: json['transliteration'] as String?,
      verseTranslation:
          (json['verse_translation'] as List<dynamic>?)
              ?.map((e) => VerseTranslation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$BookmarkVerseToJson(BookmarkVerse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapter_number': instance.chapterNumber,
      'verse_number': instance.verseNumber,
      'text': instance.text,
      'transliteration': instance.transliteration,
      'verse_translation': instance.verseTranslation,
    };
