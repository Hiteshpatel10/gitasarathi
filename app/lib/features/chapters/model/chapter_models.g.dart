// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
  id: (json['id'] as num).toInt(),
  chapterNumber: (json['chapter_number'] as num).toInt(),
  chapterSummary: json['chapter_summary'] as String,
  chapterSummaryHindi: json['chapter_summary_hindi'] as String,
  imageName: json['image_name'] as String,
  imageUrl: json['image_url'] as String,
  name: json['name'] as String,
  nameMeaning: json['name_meaning'] as String,
  nameTranslation: json['name_translation'] as String,
  nameTransliterated: json['name_transliterated'] as String,
  versesCount: (json['verses_count'] as num).toInt(),
  progress: (json['progress'] as num?)?.toDouble(),
  listenProgress: (json['listen_progress'] as num?)?.toDouble(),
  readVerses: (json['read_verses'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
  'id': instance.id,
  'chapter_number': instance.chapterNumber,
  'chapter_summary': instance.chapterSummary,
  'chapter_summary_hindi': instance.chapterSummaryHindi,
  'image_name': instance.imageName,
  'image_url': instance.imageUrl,
  'name': instance.name,
  'name_meaning': instance.nameMeaning,
  'name_translation': instance.nameTranslation,
  'name_transliterated': instance.nameTransliterated,
  'verses_count': instance.versesCount,
  'progress': instance.progress,
  'listen_progress': instance.listenProgress,
  'read_verses': instance.readVerses,
};

UserProgressData _$UserProgressDataFromJson(Map<String, dynamic> json) =>
    UserProgressData(
      reads:
          (json['reads'] as List<dynamic>?)
              ?.map((e) => ChapterProgress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      listens:
          (json['listens'] as List<dynamic>?)
              ?.map((e) => ChapterProgress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$UserProgressDataToJson(UserProgressData instance) =>
    <String, dynamic>{'reads': instance.reads, 'listens': instance.listens};

ChapterProgress _$ChapterProgressFromJson(Map<String, dynamic> json) =>
    ChapterProgress(
      chapter: (json['chapter'] as num).toInt(),
      progress: (json['progress'] as num).toDouble(),
      verses: json['verses'] as String?,
    );

Map<String, dynamic> _$ChapterProgressToJson(ChapterProgress instance) =>
    <String, dynamic>{
      'chapter': instance.chapter,
      'progress': instance.progress,
      'verses': instance.verses,
    };
