class OnboardingModel {
  OnboardingModel({
    this.appUpdate,
    this.googleReview,
    this.status,
  });

  OnboardingModel.fromJson(dynamic json) {
    appUpdate = json['app_update'] != null ? AppUpdate.fromJson(json['app_update']) : null;
    googleReview =
        json['google_review'] != null ? GoogleReview.fromJson(json['google_review']) : null;
    status = json['status'];
  }
  AppUpdate? appUpdate;
  GoogleReview? googleReview;
  num? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (appUpdate != null) {
      map['app_update'] = appUpdate?.toJson();
    }
    if (googleReview != null) {
      map['google_review'] = googleReview?.toJson();
    }
    map['status'] = status;
    return map;
  }
}

class GoogleReview {
  GoogleReview({
    this.buildNo,
    this.token,
  });

  GoogleReview.fromJson(dynamic json) {
    buildNo = json['build_no'];
    token = json['token'];
    inReview = json['in_review'];
  }
  num? buildNo;
  bool? inReview;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['build_no'] = buildNo;
    map['token'] = token;
    return map;
  }
}

class AppUpdate {
  AppUpdate({
    this.buildNo,
    this.forceUpdate,
    this.message,
    this.softUpdate,
    this.title,
  });

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
