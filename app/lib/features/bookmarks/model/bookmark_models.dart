import 'package:json_annotation/json_annotation.dart';
import 'package:app/features/chapters/model/verse_models.dart';

part 'bookmark_models.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BookmarkItem {
  BookmarkItem({
    required this.id,
    required this.userId,
    required this.verseId,
    this.createdAt,
    this.verse,
  });

  final int id;
  final int userId;
  final int verseId;
  final DateTime? createdAt;
  final BookmarkVerse? verse;

  factory BookmarkItem.fromJson(Map<String, dynamic> json) => _$BookmarkItemFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkItemToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BookmarkVerse {
  BookmarkVerse({
    required this.id,
    required this.chapterNumber,
    required this.verseNumber,
    this.text,
    this.transliteration,
    this.verseTranslation,
  });

  final int id;
  final int chapterNumber;
  final int verseNumber;
  final String? text;
  final String? transliteration;
  
  @JsonKey(defaultValue: [])
  final List<VerseTranslation>? verseTranslation;

  factory BookmarkVerse.fromJson(Map<String, dynamic> json) => _$BookmarkVerseFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkVerseToJson(this);
}
