class KeyValuePairModel<T, R, S> {
  KeyValuePairModel({
    required this.key,
    required this.value,
    this.extra,
  });

  T key;
  R value;
  S? extra;

  // Converts the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'extra': extra,
    };
  }

  // Creates an object from JSON
  static KeyValuePairModel<T, R, S> fromJson<T, R, S>(
      Map<String, dynamic> json,
      ) {
    return KeyValuePairModel<T, R, S>(
      key: json['key'],
      value: json['value'],
      extra: json['extra'],
    );
  }
}
