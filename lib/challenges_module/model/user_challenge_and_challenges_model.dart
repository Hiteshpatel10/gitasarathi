import 'package:chapter/main.dart';

class UserChallengeAndChallengesModel {
  UserChallengeAndChallengesModel({
    this.challenges,
    this.enrolledInChallenge,
    this.status,
    this.userChallenges,
  });

  UserChallengeAndChallengesModel.fromJson(dynamic json) {
    if (json['challenges'] != null) {
      challenges = [];
      json['challenges'].forEach((v) {
        challenges?.add(Challenge.fromJson(v));
      });
    }
    enrolledInChallenge = json['enrolled_in_challenge'];

    logger.d(json['enrolled_in_challenge']);
    status = json['status'];
    if (json['user_challenges'] != null) {
      userChallenges = [];
      json['user_challenges'].forEach((v) {
        userChallenges?.add(UserChallenges.fromJson(v));
      });
    }
  }
  List<Challenge>? challenges;
  bool? enrolledInChallenge;
  num? status;
  List<UserChallenges>? userChallenges;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (challenges != null) {
      map['challenges'] = challenges?.map((v) => v.toJson()).toList();
    }
    map['enrolled_in_challenge'] = enrolledInChallenge;

    map['status'] = status;
    if (userChallenges != null) {
      map['user_challenges'] = userChallenges?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UserChallenges {
  UserChallenges({
    this.id,
    this.userId,
    this.challengeId,
    this.daysCompleted,
    this.missedDays,
    this.status,
    this.startDate,
    this.endDate,
    this.completedAt,
    this.updatedAt,
    this.challenge,
    this.timeline,
  });

  UserChallenges.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    challengeId = json['challenge_id'];
    daysCompleted = json['days_completed'];
    missedDays = json['missed_days'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    completedAt = json['completed_at'];
    updatedAt = json['updated_at'];
    challenge = json['challenge'] != null ? Challenge.fromJson(json['challenge']) : null;

    isTaskDoneNow = json['is_task_done_now'];
    if (json['timeline'] != null) {
      timeline = {};
      (json['timeline'] as Map<String, dynamic>).forEach((key, value) {
        timeline![DateTime.tryParse(key)] = value.toString();
      });
    }
  }
  num? id;
  num? userId;
  num? challengeId;
  num? daysCompleted;
  num? missedDays;
  String? status;
  String? startDate;
  String? endDate;
  String? completedAt;
  String? updatedAt;
  bool? isTaskDoneNow;
  Challenge? challenge;
  Map<DateTime?, String>? timeline;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['challenge_id'] = challengeId;
    map['days_completed'] = daysCompleted;
    map['missed_days'] = missedDays;
    map['status'] = status;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['completed_at'] = completedAt;
    map['updated_at'] = updatedAt;
    if (challenge != null) {
      map['challenge'] = challenge?.toJson();
    }
    if (timeline != null) {
      // map['timeline'] = timeline?.toJson();
    }
    return map;
  }
}

class Challenge {
  Challenge({
    this.id,
    this.name,
    this.description,
    this.daysRequired,
    this.type,
    this.flexibleDays,
    this.icon,
    this.coverImage,
    this.createdAt,
    this.updatedAt,
  });

  Challenge.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    daysRequired = json['days_required'];
    type = json['type'];
    flexibleDays = json['flexible_days'];
    icon = json['icon'];
    coverImage = json['cover_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? name;
  String? description;
  num? daysRequired;
  String? type;
  num? flexibleDays;
  String? icon;
  String? coverImage;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['days_required'] = daysRequired;
    map['type'] = type;
    map['flexible_days'] = flexibleDays;
    map['icon'] = icon;
    map['cover_image'] = coverImage;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
