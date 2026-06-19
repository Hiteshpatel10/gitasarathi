import 'package:chapter/favourite_module/model/favourite_model.dart' as favourite_model;

class VerseExplanationModel {
  VerseExplanationModel({
    this.message,
    this.result,
    this.status,
  });

  VerseExplanationModel.fromJson(dynamic json) {
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    status = json['status'];
  }
  String? message;
  Result? result;
  num? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (result != null) {
      map['result'] = result?.toJson();
    }
    map['status'] = status;
    return map;
  }
}

class Result {
  Result({
    this.id,
    this.chapterId,
    this.chapterNumber,
    this.externalId,
    this.text,
    this.title,
    this.verseNumber,
    this.verseOrder,
    this.transliteration,
    this.wordMeanings,
    this.verseTranslation,
    this.verseCommentary,
  });

  Result.fromJson(dynamic json) {
    id = json['id'];
    chapterId = json['chapter_id'];
    chapterNumber = json['chapter_number'];
    externalId = json['external_id'];
    text = json['text'];
    title = json['title'];
    verseNumber = json['verse_number'];
    verseOrder = json['verse_order'];
    transliteration = json['transliteration'];
    wordMeanings = json['word_meanings'];
    if (json['verse_translation'] != null) {
      verseTranslation = [];
      json['verse_translation'].forEach((v) {
        verseTranslation?.add(VerseExplanation.fromJson(v));
      });
    }
    if (json['verse_commentary'] != null) {
      verseCommentary = [];
      json['verse_commentary'].forEach((v) {
        verseCommentary?.add(VerseExplanation.fromJson(v));
      });
    }

    if (json['favorites'] != null) {
      favorites = [];
      json['favorites'].forEach((v) {
        favorites?.add(Favorites.fromJson(v));
      });
    }
  }
  num? id;
  num? chapterId;
  num? chapterNumber;
  num? externalId;
  String? text;
  String? title;
  num? verseNumber;
  num? verseOrder;
  String? transliteration;
  String? wordMeanings;
  List<VerseExplanation>? verseTranslation;
  List<VerseExplanation>? verseCommentary;
  List<Favorites>? favorites;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['chapter_id'] = chapterId;
    map['chapter_number'] = chapterNumber;
    map['external_id'] = externalId;
    map['text'] = text;
    map['title'] = title;
    map['verse_number'] = verseNumber;
    map['verse_order'] = verseOrder;
    map['transliteration'] = transliteration;
    map['word_meanings'] = wordMeanings;
    if (verseTranslation != null) {
      map['verse_translation'] = verseTranslation?.map((v) => v.toJson()).toList();
    }
    if (verseCommentary != null) {
      map['verse_commentary'] = verseCommentary?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class VerseExplanation {
  VerseExplanation({
    this.id,
    this.authorName,
    this.authorId,
    this.description,
    this.lang,
    this.languageId,
    this.verseNumber,
    this.verseId,
  });

  VerseExplanation.fromJson(dynamic json) {
    id = json['id'];
    authorName = json['author_name'];
    authorId = json['author_id'];
    description = json['description'];
    lang = json['lang'];
    languageId = json['language_id'];
    verseNumber = json['verse_number'];
    verseId = json['verse_id'];
  }
  num? id;
  String? authorName;
  num? authorId;
  String? description;
  String? lang;
  num? languageId;
  num? verseNumber;
  num? verseId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['author_name'] = authorName;
    map['author_id'] = authorId;
    map['description'] = description;
    map['lang'] = lang;
    map['language_id'] = languageId;
    map['verse_number'] = verseNumber;
    map['verse_id'] = verseId;
    return map;
  }
}

class Favorites {
  Favorites({
    this.id,
    this.userId,
    this.verseId,
    this.createdAt,
    this.updatedAt,
  });

  Favorites.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    verseId = json['verse_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  num? userId;
  num? verseId;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['verse_id'] = verseId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
