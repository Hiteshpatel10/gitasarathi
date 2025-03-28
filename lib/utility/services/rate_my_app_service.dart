import 'dart:io';
import 'package:chapter/user_module/cubit/user_activity_cubit.dart';
import 'package:chapter/user_module/cubit/user_cubit.dart';
import 'package:chapter/utility/messengers/core_scaffold_messenger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rate_my_app/rate_my_app.dart';

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 3,
  minLaunches: 5,
  remindDays: 5,
  remindLaunches: 10,
  googlePlayIdentifier: 'com.gitasarathi',
);

Future<void> rateUs(BuildContext context, {bool showError = false}) async {
  await rateMyApp.init();

  if (rateMyApp.shouldOpenDialog) {
    rateMyApp.showRateDialog(
      context,
      title: 'Enjoying the App?',
      message:
          'If you find this app useful, please take a moment to rate it. Your support helps us improve!',
      rateButton: 'RATE NOW',
      noButton: 'NO, THANKS',
      laterButton: 'REMIND ME LATER',
      listener: (button) {
        switch (button) {
          case RateMyAppDialogButton.rate:
            BlocProvider.of<UserCubit>(context).insertUserActivity(activity: "Rate Now");
            rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
            break;
          case RateMyAppDialogButton.later:
            BlocProvider.of<UserCubit>(context).insertUserActivity(activity: "Rate Later");
            rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
            break;
          case RateMyAppDialogButton.no:
            BlocProvider.of<UserCubit>(context).insertUserActivity(activity: "Rate No");
            rateMyApp.callEvent(RateMyAppEventType.noButtonPressed);
            break;
        }
        return true;
      },
      ignoreNativeDialog: Platform.isAndroid,
      dialogStyle: const DialogStyle(),
      onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
    );
  } else {
    if (showError) coreMessenger("Please use the app a little more before rating!");
  }
}
