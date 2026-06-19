class VerseModel {
  VerseModel({
    this.message,
    this.result,
    this.status,
  });

  VerseModel.fromJson(dynamic json) {
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
    this.chapter,
    this.verse,
    this.slok,
    this.transliteration,
    this.comments,
  });

  Result.fromJson(dynamic json) {
    id = json['_id'];
    chapter = json['chapter'];
    verse = json['verse'];
    slok = json['slok'];
    transliteration = json['transliteration'];
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(Comments.fromJson(v));
      });
    }
  }
  String? id;
  num? chapter;
  num? verse;
  String? slok;
  String? transliteration;
  List<Comments>? comments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['chapter'] = chapter;
    map['verse'] = verse;
    map['slok'] = slok;
    map['transliteration'] = transliteration;
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Comments {
  Comments({
    this.languages,
    this.author,
  });

  Comments.fromJson(dynamic json) {
    if (json['languages'] != null) {
      languages = [];
      json['languages'].forEach((v) {
        languages?.add(Languages.fromJson(v));
      });
    }
    author = json['author'];
  }
  List<Languages>? languages;
  String? author;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (languages != null) {
      map['languages'] = languages?.map((v) => v.toJson()).toList();
    }
    map['author'] = author;
    return map;
  }
}

class Languages {
  Languages({
    this.language,
    this.text,
  });

  Languages.fromJson(dynamic json) {
    language = json['language'];
    text = json['text'];
  }
  String? language;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['language'] = language;
    map['text'] = text;
    return map;
  }
}
