import 'package:chapter/verse_module/model/verse_explanation_model.dart' as verse_explanation_model;

class FavouriteModel {
  FavouriteModel({
    this.favorites,
    this.status,
  });

  FavouriteModel.fromJson(dynamic json) {
    if (json['favorites'] != null) {
      favorites = [];
      json['favorites'].forEach((v) {
        favorites?.add(Favorites.fromJson(v));
      });
    }
    status = json['status'];
  }
  List<Favorites>? favorites;
  num? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (favorites != null) {
      map['favorites'] = favorites?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
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
    verse = verse_explanation_model.Result.fromJson(json['verse']);
  }
  num? id;
  num? userId;
  num? verseId;
  String? createdAt;
  String? updatedAt;
  verse_explanation_model.Result? verse;

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
