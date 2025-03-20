class LanguageAndAuthorModel {
  LanguageAndAuthorModel({
    this.message,
    this.result,
    this.status,
  });

  LanguageAndAuthorModel.fromJson(dynamic json) {
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
    this.language,
    this.authors,
  });

  Result.fromJson(dynamic json) {
    id = json['id'];
    language = json['language'];
    if (json['authors'] != null) {
      authors = [];
      json['authors'].forEach((v) {
        authors?.add(Authors.fromJson(v));
      });
    }
  }
  num? id;
  String? language;
  List<Authors>? authors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['language'] = language;
    if (authors != null) {
      map['authors'] = authors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Authors {
  Authors({
    this.id,
    this.name,
    this.authorDescription,
    this.comment,
    this.translation,
    this.languageId,
  });

  Authors.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    authorDescription = json['author_description'];
    comment = json['comment'];
    translation = json['translation'];
    languageId = json['language_id'];
  }
  num? id;
  String? name;
  dynamic authorDescription;
  num? comment;
  num? translation;
  num? languageId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['author_description'] = authorDescription;
    map['comment'] = comment;
    map['translation'] = translation;
    map['language_id'] = languageId;
    return map;
  }
}
