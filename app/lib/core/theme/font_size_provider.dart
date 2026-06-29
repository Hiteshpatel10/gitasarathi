import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/services/pref_service.dart';
import 'package:app/core/constants/pref_keys.dart';

class FontSizeNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(prefServiceProvider);
    final savedSize = prefs.getString(PrefKeys.userFontSize);
    if (savedSize != null && ['S', 'M', 'L'].contains(savedSize)) {
      return savedSize;
    }
    return 'M';
  }

  Future<void> setFontSize(String size) async {
    if (['S', 'M', 'L'].contains(size)) {
      final prefs = ref.read(prefServiceProvider);
      await prefs.setString(PrefKeys.userFontSize, size);
      state = size;
    }
  }

  double get scaleFactor {
    switch (state) {
      case 'S':
        return 0.85;
      case 'L':
        return 1.15;
      case 'M':
      default:
        return 1.0;
    }
  }
}

final fontSizeProvider = NotifierProvider<FontSizeNotifier, String>(() {
  return FontSizeNotifier();
});
