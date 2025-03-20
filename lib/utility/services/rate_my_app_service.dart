import 'dart:io';
import 'package:chapter/utility/messengers/core_scaffold_messenger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:rate_my_app/rate_my_app.dart';

// RateMyApp rateMyApp = RateMyApp(
//   preferencesPrefix: 'rateMyApp_',
//   minDays: 1,
//   minLaunches: 5,
//   remindDays: 3,
//   remindLaunches: 10,
//   googlePlayIdentifier: 'com.gitasarathi',
// );

Future<void> rateUs(BuildContext context) async {
  // await rateMyApp.init();
  //
  // if (rateMyApp.shouldOpenDialog) {
  //   rateMyApp.showRateDialog(
  //     context,
  //     title: 'Enjoying the App?',
  //     message:
  //         'If you find this app useful, please take a moment to rate it. Your support helps us improve!',
  //     rateButton: 'RATE NOW',
  //     noButton: 'NO, THANKS',
  //     laterButton: 'REMIND ME LATER',
  //     listener: (button) {
  //       switch (button) {
  //         case RateMyAppDialogButton.rate:
  //           rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
  //           break;
  //         case RateMyAppDialogButton.later:
  //           rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
  //           break;
  //         case RateMyAppDialogButton.no:
  //           rateMyApp.callEvent(RateMyAppEventType.noButtonPressed);
  //           break;
  //       }
  //       return true;
  //     },
  //     ignoreNativeDialog: Platform.isAndroid,
  //     dialogStyle: const DialogStyle(),
  //     onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
  //   );
  // } else {
  //   coreMessenger("Please use the app a little more before rating!");
  // }
}
