import 'package:json_annotation/json_annotation.dart';

part 'verse_models.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VerseDetails {
  VerseDetails({
    required this.id,
    required this.chapterId,
    required this.chapterNumber,
    required this.externalId,
    required this.text,
    required this.title,
    required this.verseNumber,
    required this.verseOrder,
    required this.transliteration,
    required this.wordMeanings,
    this.translations = const [],
    this.commentaries = const [],
  });

  final int id;
  final int chapterId;
  final int chapterNumber;
  final int externalId;
  final String text;
  final String title;
  final int verseNumber;
  final int verseOrder;
  final String transliteration;
  final String wordMeanings;

  @JsonKey(name: 'verse_translation', defaultValue: [])
  final List<VerseTranslation> translations;

  @JsonKey(name: 'verse_commentary', defaultValue: [])
  final List<VerseCommentary> commentaries;

  factory VerseDetails.fromJson(Map<String, dynamic> json) => _$VerseDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$VerseDetailsToJson(this);

  /// Helper to parse the word_meanings string into a list of word/meaning pairs.
  List<WordMeaning> get parsedWordMeanings {
    final pairs = <WordMeaning>[];
    if (wordMeanings.isEmpty) return pairs;
    
    // Split by semicolon or newline
    final parts = wordMeanings.split(RegExp(r'[;\n]'));
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;

      // Some use em-dash '—' or regular dash '-'
      final splitIndex = trimmed.indexOf('—') != -1 ? trimmed.indexOf('—') : trimmed.indexOf('-');
      if (splitIndex != -1) {
        final word = trimmed.substring(0, splitIndex).trim();
        final meaning = trimmed.substring(splitIndex + 1).trim();
        pairs.add(WordMeaning(word: word, meaning: meaning));
      } else {
        pairs.add(WordMeaning(word: trimmed, meaning: ''));
      }
    }
    return pairs;
  }
}

class WordMeaning {
  WordMeaning({required this.word, required this.meaning});
  final String word;
  final String meaning;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VerseTranslation {
  VerseTranslation({
    required this.id,
    required this.authorName,
    required this.authorId,
    required this.description,
    required this.lang,
    required this.languageId,
  });

  final int id;
  final String authorName;
  final int authorId;
  final String description;
  final String lang;
  final int languageId;

  factory VerseTranslation.fromJson(Map<String, dynamic> json) => _$VerseTranslationFromJson(json);
  Map<String, dynamic> toJson() => _$VerseTranslationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VerseCommentary {
  VerseCommentary({
    required this.id,
    required this.authorName,
    required this.authorId,
    required this.description,
    required this.lang,
    required this.languageId,
  });

  final int id;
  final String authorName;
  final int authorId;
  final String description;
  final String lang;
  final int languageId;

  factory VerseCommentary.fromJson(Map<String, dynamic> json) => _$VerseCommentaryFromJson(json);
  Map<String, dynamic> toJson() => _$VerseCommentaryToJson(this);
}
