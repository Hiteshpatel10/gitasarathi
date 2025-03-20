import 'dart:io';
import 'package:chapter/home_module/model/onboarding_model.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/navigation/go_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

appUpdateCheck({AppUpdate? appUpdate}) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String buildNumber = packageInfo.buildNumber;
  bool updateAvailable = (appUpdate?.buildNo ?? 0) > int.parse(buildNumber);

  if (updateAvailable == false) {
    return;
  }

  _handleInAppUpdate(appUpdate);

  if (appUpdate?.forceUpdate == 1) {
    Future.delayed(Duration.zero, () => _handleForceUpdate(appUpdate));
    return;
  }

  if (appUpdate?.softUpdate == 1) {
    return;
  }
}

_handleInAppUpdate(AppUpdate? appUpdate) async {
  final updateInfo = await InAppUpdate.checkForUpdate();

  if (updateInfo.updateAvailability == UpdateAvailability.updateNotAvailable) {
    return;
  }

  if (appUpdate?.forceUpdate == 1) {
    debugPrint('FORCE UPDATE STARTED');
    InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
      if (appUpdateResult == AppUpdateResult.success) {}
    });
  } else if (appUpdate?.softUpdate == 1) {
    debugPrint('SOFT UPDATE STARTED');

    InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
      if (appUpdateResult == AppUpdateResult.success) {
        InAppUpdate.completeFlexibleUpdate();
      }
    });
  }
}

_handleForceUpdate(AppUpdate? appUpdate) {
  BuildContext? context = globalNavigatorKey.currentContext ??
      globalNavigatorKey.currentState?.overlay?.context;

  if (context == null) {
    return;
  }
  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: CupertinoAlertDialog(
          title: Text(appUpdate?.title ?? 'Update Available'),
          content: Text(
              appUpdate?.message ?? 'A new version of the app is available.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Update'),
              onPressed: () async {
                _launchStore();
              },
            ),
            if (appUpdate?.forceUpdate == 0)
              CupertinoDialogAction(
                child: const Text('Close'),
                onPressed: () {
                  goRouter.pop();
                },
              ),
          ],
        ),
      );
    },
  );
}

void _launchStore() async {
  if (Platform.isAndroid || Platform.isIOS) {
    final appId = Platform.isAndroid ? 'com.gitasarathi' : '1246082058';
    final uri = Platform.isAndroid
        ? 'market://details?id=$appId'
        : 'https://apps.apple.com/gb/app/id$appId';

    final url = Uri.parse(uri);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch Store URL';
    }
  }
}
