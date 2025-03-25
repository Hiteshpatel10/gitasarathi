import 'package:chapter/main.dart';

class UserActivityModel {
  UserActivityModel({
    this.readCalendar,
    this.status,
    this.streak,
    this.userActivity,
    this.verseRead,
  });

  UserActivityModel.fromJson(dynamic json) {
    if (json['read_calendar'] != null) {
      readCalendar = {};
      json['read_calendar'].forEach((key, value) {
        DateTime parsedDate = DateTime.parse(key);
        readCalendar![parsedDate] = value;
      });
    }

    status = json['status'];
    streak = json['streak'];
    if (json['user_activity'] != null) {
      userActivity = [];
      json['user_activity'].forEach((v) {
        userActivity?.add(UserActivity.fromJson(v));
      });
    }
    verseRead = json['verse_read'];
  }
  Map<DateTime, bool>? readCalendar;
  num? status;
  num? streak;
  List<UserActivity>? userActivity;
  num? verseRead;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (readCalendar != null) {
      map['read_calendar'] = readCalendar;
    }
    map['status'] = status;
    map['streak'] = streak;
    if (userActivity != null) {
      map['user_activity'] = userActivity?.map((v) => v.toJson()).toList();
    }
    map['verse_read'] = verseRead;
    return map;
  }
}

class UserActivity {
  UserActivity({
    this.id,
    this.userId,
    this.activity,
    this.chapterId,
    this.verseId,
    this.createdAt,
    this.updatedAt,
  });

  UserActivity.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    activity = json['activity'];
    chapterId = json['chapter_id'];
    verseId = json['verse_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  num? userId;
  String? activity;
  num? chapterId;
  num? verseId;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['activity'] = activity;
    map['chapter_id'] = chapterId;
    map['verse_id'] = verseId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
