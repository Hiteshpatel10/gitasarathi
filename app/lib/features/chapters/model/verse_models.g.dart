// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerseDetails _$VerseDetailsFromJson(Map<String, dynamic> json) => VerseDetails(
  id: (json['id'] as num).toInt(),
  chapterId: (json['chapter_id'] as num).toInt(),
  chapterNumber: (json['chapter_number'] as num).toInt(),
  externalId: (json['external_id'] as num).toInt(),
  text: json['text'] as String,
  title: json['title'] as String,
  verseNumber: (json['verse_number'] as num).toInt(),
  verseOrder: (json['verse_order'] as num).toInt(),
  transliteration: json['transliteration'] as String,
  wordMeanings: json['word_meanings'] as String,
  translations:
      (json['verse_translation'] as List<dynamic>?)
          ?.map((e) => VerseTranslation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  commentaries:
      (json['verse_commentary'] as List<dynamic>?)
          ?.map((e) => VerseCommentary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  audioLinks: json['audio_links'] == null
      ? null
      : AudioLinks.fromJson(json['audio_links'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VerseDetailsToJson(VerseDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapter_id': instance.chapterId,
      'chapter_number': instance.chapterNumber,
      'external_id': instance.externalId,
      'text': instance.text,
      'title': instance.title,
      'verse_number': instance.verseNumber,
      'verse_order': instance.verseOrder,
      'transliteration': instance.transliteration,
      'word_meanings': instance.wordMeanings,
      'verse_translation': instance.translations,
      'verse_commentary': instance.commentaries,
      'audio_links': instance.audioLinks,
    };

VerseTranslation _$VerseTranslationFromJson(Map<String, dynamic> json) =>
    VerseTranslation(
      id: (json['id'] as num).toInt(),
      authorName: json['author_name'] as String,
      authorId: (json['author_id'] as num).toInt(),
      description: json['description'] as String,
      lang: json['lang'] as String,
      languageId: (json['language_id'] as num).toInt(),
    );

Map<String, dynamic> _$VerseTranslationToJson(VerseTranslation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_name': instance.authorName,
      'author_id': instance.authorId,
      'description': instance.description,
      'lang': instance.lang,
      'language_id': instance.languageId,
    };

VerseCommentary _$VerseCommentaryFromJson(Map<String, dynamic> json) =>
    VerseCommentary(
      id: (json['id'] as num).toInt(),
      authorName: json['author_name'] as String,
      authorId: (json['author_id'] as num).toInt(),
      description: json['description'] as String,
      lang: json['lang'] as String,
      languageId: (json['language_id'] as num).toInt(),
    );

Map<String, dynamic> _$VerseCommentaryToJson(VerseCommentary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_name': instance.authorName,
      'author_id': instance.authorId,
      'description': instance.description,
      'lang': instance.lang,
      'language_id': instance.languageId,
    };

AudioLinks _$AudioLinksFromJson(Map<String, dynamic> json) => AudioLinks(
  moolFemale: json['mool_female'] as String?,
  moolMale: json['mool_male'] as String?,
  englishFemaleTranslation: json['english_female_translation'] as String?,
  hindiFemaleTranslation: json['hindi_female_translation'] as String?,
);

Map<String, dynamic> _$AudioLinksToJson(AudioLinks instance) =>
    <String, dynamic>{
      'mool_female': instance.moolFemale,
      'mool_male': instance.moolMale,
      'english_female_translation': instance.englishFemaleTranslation,
      'hindi_female_translation': instance.hindiFemaleTranslation,
    };
