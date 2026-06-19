class OnboardingModel {
  OnboardingModel({
    this.appUpdate,
    this.googleReview,
    this.highlights,
    this.status,
  });

  OnboardingModel.fromJson(dynamic json) {
    appUpdate = json['app_update'] != null ? AppUpdate.fromJson(json['app_update']) : null;
    googleReview =
        json['google_review'] != null ? GoogleReview.fromJson(json['google_review']) : null;
    if (json['highlights'] != null) {
      highlights = [];
      json['highlights'].forEach((v) {
        highlights?.add(Highights.fromJson(v));
      });
    }
    status = json['status'];
  }
  AppUpdate? appUpdate;
  GoogleReview? googleReview;
  List<Highights>? highlights;
  num? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (appUpdate != null) {
      map['app_update'] = appUpdate?.toJson();
    }
    if (googleReview != null) {
      map['google_review'] = googleReview?.toJson();
    }
    if (highlights != null) {
      map['highlights'] = highlights?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    return map;
  }
}

class Highights {
  Highights({
    this.bgColor,
    this.image,
    this.text,
    this.textColor,
    this.title,
  });

  Highights.fromJson(dynamic json) {
    bgColor = json['bg_color'];
    image = json['image'];
    text = json['text'];
    textColor = json['text_color'];
    title = json['title'];
  }
  String? bgColor;
  String? image;
  String? text;
  String? textColor;
  String? title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bg_color'] = bgColor;
    map['image'] = image;
    map['text'] = text;
    map['text_color'] = textColor;
    map['title'] = title;
    return map;
  }
}

class GoogleReview {
  GoogleReview({
    this.buildNo,
    this.inReview,
    this.token,
  });

  GoogleReview.fromJson(dynamic json) {
    buildNo = json['build_no'];
    inReview = json['in_review'];
    token = json['token'];
  }
  num? buildNo;
  bool? inReview;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['build_no'] = buildNo;
    map['in_review'] = inReview;
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
