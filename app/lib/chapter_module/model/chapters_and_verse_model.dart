class ChaptersAndVerseModel {
  ChaptersAndVerseModel({
    this.message,
    this.result,
    this.status,
  });

  ChaptersAndVerseModel.fromJson(dynamic json) {
    message = json['message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
    status = json['status'];
  }
  String? message;
  List<Result>? result;
  num? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (result != null) {
      map['result'] = result?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    return map;
  }
}

class Result {
  Result({
    this.id,
    this.chapterNumber,
    this.chapterSummary,
    this.chapterSummaryHindi,
    this.imageName,
    this.name,
    this.nameMeaning,
    this.nameTranslation,
    this.nameTransliterated,
    this.versesCount,
    this.verses,
  });

  Result.fromJson(dynamic json) {
    id = json['id'];
    chapterNumber = json['chapter_number'];
    chapterSummary = json['chapter_summary'];
    bannerImage = json['banner_image'];
    chapterSummaryHindi = json['chapter_summary_hindi'];
    imageName = json['image_name'];
    coverImage = json['cover_image'];
    name = json['name'];
    nameMeaning = json['name_meaning'];
    nameTranslation = json['name_translation'];
    nameTransliterated = json['name_transliterated'];
    versesCount = json['verses_count'];
    progress = json['progress'];
    if (json['verses'] != null) {
      verses = [];
      json['verses'].forEach((v) {
        verses?.add(Verses.fromJson(v));
      });
    }
  }
  num? id;
  num? chapterNumber;
  String? chapterSummary;
  String? bannerImage;
  String? chapterSummaryHindi;
  String? imageName;
  String? coverImage;
  String? name;
  String? nameMeaning;
  String? nameTranslation;
  String? nameTransliterated;
  num? versesCount;
  num? progress;
  List<Verses>? verses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['chapter_number'] = chapterNumber;
    map['chapter_summary'] = chapterSummary;
    map['chapter_summary_hindi'] = chapterSummaryHindi;
    map['image_name'] = imageName;
    map['name'] = name;
    map['name_meaning'] = nameMeaning;
    map['name_translation'] = nameTranslation;
    map['name_transliterated'] = nameTransliterated;
    map['verses_count'] = versesCount;
    if (verses != null) {
      map['verses'] = verses?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Verses {
  Verses({
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

  Verses.fromJson(dynamic json) {
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
    verseTranslation = json['verse_translation'];
    verseCommentary = json['verse_commentary'];
    isRead = json['is_read'];
  }
  num? id;
  num? chapterId;
  num? chapterNumber;
  num? externalId;
  String? text;
  String? title;
  num? verseNumber;
  num? verseOrder;
  bool? isRead;
  String? transliteration;
  String? wordMeanings;
  dynamic verseTranslation;
  dynamic verseCommentary;

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
    map['verse_translation'] = verseTranslation;
    map['verse_commentary'] = verseCommentary;
    return map;
  }
}
