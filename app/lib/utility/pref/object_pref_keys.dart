import 'dart:convert';

import 'package:chapter/main.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ObjectPref {
  static setData(String key, {Map<String, dynamic>? data}) {
    if (data == null) return;
    prefs.setString(key, jsonEncode(data));
  }

  static T? getData<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final data = prefs.getString(key); // FIX: Use getString instead of get

    if (data == null) return null;

    logger.t("ObjectPref => $key > cache");

    try {
      return fromJson(jsonDecode(data));
    } catch (e) {
      logger.e("Error decoding $key: $e");
      return null;
    }
  }

  static runCacheValidator(
    Map<String, dynamic>? data,
    String? cacheClearFrequency, {
    Function? onInvalidCache,
  }) async {
    if (data == null) return;

    bool isInValid = false;
    bool isCacheClearDay = _isClearCacheToday(cacheClearFrequency);

    // final buildNo = prefs.read<int?>(ObjectPrefKeys.appBuildNo);
    //
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // final appBuildNo = int.tryParse(packageInfo.buildNumber);
    //
    // if (buildNo == null && appBuildNo != null) {
    //   pref.write(ObjectPrefKeys.appBuildNo, appBuildNo);
    // } else if (appBuildNo != null && buildNo != null && buildNo < appBuildNo) {
    //   isInValid = true;
    //   pref.write(ObjectPrefKeys.appBuildNo, appBuildNo);
    // }

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      final versionKey = '${key}_version';
      final storedVersion = prefs.getInt(versionKey);

      if ((storedVersion != null && storedVersion < value) || isCacheClearDay) {
        prefs.remove(key);
        logger.i("runCacheValidator Removing key - $key | $storedVersion < $value");
        isInValid = true;
      }

      prefs.setInt(versionKey, value);
    }

    if (isInValid) {
      logger.i("runCacheValidator - valid $isInValid - $isCacheClearDay");
      if (onInvalidCache != null) onInvalidCache();
    }
  }

  static bool _isClearCacheToday(String? cacheClearFrequency) {
    final today = DateTime.now();
    final cacheDate = prefs.getString(AppPrefKeys.lastCacheDate);
    final lastCacheDate = cacheDate == null ? null : DateTime.tryParse(cacheDate);

    if (lastCacheDate == null) {
      // No previous cache date found, so mark as cleared and log
      prefs.setString(AppPrefKeys.lastCacheDate, today.toIso8601String());
      logger.i("CacheClear - No previous date, clearing cache for today: $today");
      return true;
    }

    bool isCacheClearedToday = lastCacheDate.year == today.year &&
        lastCacheDate.month == today.month &&
        lastCacheDate.day == today.day;

    if (cacheClearFrequency == "EVERYTIME") {
      prefs.setString(AppPrefKeys.lastCacheDate, today.toIso8601String());
      logger.i("CacheClear - Cleared on EVERYTIME frequency. Date: $today");
      return true;
    }

    if (cacheClearFrequency == "DAILY") {
      if (isCacheClearedToday == false) {
        prefs.setString(AppPrefKeys.lastCacheDate, today.toIso8601String());
        logger.i("CacheClear - Not cleared today. Clearing now for DAILY frequency: $today");
        return true;
      }
    }

    if (cacheClearFrequency == null || cacheClearFrequency == "WEEKLY") {
      if (today.weekday == DateTime.monday && isCacheClearedToday == false) {
        prefs.setString(AppPrefKeys.lastCacheDate, today.toIso8601String());
        logger
            .i("CacheClear - Monday, not cleared this week. Clearing for WEEKLY frequency: $today");
        return true;
      }
    }

    if (cacheClearFrequency == "MONTHLY") {
      if (today.day == 1 && isCacheClearedToday == false) {
        prefs.setString(AppPrefKeys.lastCacheDate, today.toIso8601String());
        logger.i(
            "CacheClear - First day of month, not cleared. Clearing for MONTHLY frequency: $today");
        return true;
      }
    }

    logger.i("CacheClear - No action, Clear Frequency $cacheClearFrequency not met: $cacheDate");
    return false;
  }
}
