class UserModel {
  UserModel({
      this.appUpdate, 
      this.result, 
      this.status,});

  UserModel.fromJson(dynamic json) {
    appUpdate = json['app_update'] != null ? AppUpdate.fromJson(json['app_update']) : null;
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    status = json['status'];
  }
  AppUpdate? appUpdate;
  Result? result;
  num? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (appUpdate != null) {
      map['app_update'] = appUpdate?.toJson();
    }
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
      this.email, 
      this.googleAuthId, 
      this.createdAt, 
      this.updatedAt, 
      this.displayName, 
      this.fcmToken, 
      this.userReads,});

  Result.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    googleAuthId = json['google_auth_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    displayName = json['display_name'];
    fcmToken = json['fcm_token'];
    if (json['user_reads'] != null) {
      userReads = [];
      json['user_reads'].forEach((v) {
        userReads?.add(UserReads.fromJson(v));
      });
    }
  }
  num? id;
  String? email;
  String? googleAuthId;
  String? createdAt;
  String? updatedAt;
  String? displayName;
  String? fcmToken;
  List<UserReads>? userReads;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['google_auth_id'] = googleAuthId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['display_name'] = displayName;
    map['fcm_token'] = fcmToken;
    if (userReads != null) {
      map['user_reads'] = userReads?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class UserReads {
  UserReads({
      this.id, 
      this.userId, 
      this.chapter, 
      this.verses, 
      this.progress, 
      this.createdAt, 
      this.updatedAt,});

  UserReads.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    chapter = json['chapter'];
    verses = json['verses'];
    progress = json['progress'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  num? userId;
  num? chapter;
  String? verses;
  num? progress;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['chapter'] = chapter;
    map['verses'] = verses;
    map['progress'] = progress;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}

class AppUpdate {
  AppUpdate({
      this.buildNo, 
      this.forceUpdate, 
      this.message, 
      this.softUpdate, 
      this.title,});

  AppUpdate.fromJson(dynamic json) {
    buildNo = json['build_no'];
    forceUpdate = json['force_update'];
    message = json['message'];
    softUpdate = json['soft_update'];
    title = json['title'];
  }
  num? buildNo;
  num? forceUpdate;
  String? message;
  num? softUpdate;
  String? title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['build_no'] = buildNo;
    map['force_update'] = forceUpdate;
    map['message'] = message;
    map['soft_update'] = softUpdate;
    map['title'] = title;
    return map;
  }

}


