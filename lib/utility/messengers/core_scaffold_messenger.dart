import 'package:chapter/main.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:flutter/material.dart';

enum CoreScaffoldMessengerType {
  success,
  error,
  warning,
  information,
}



coreMessenger(
  String content, {
  int duration = 4,
  CoreScaffoldMessengerType messageType = CoreScaffoldMessengerType.information,
}) {
  Color backgroundColor = CoreColors.whiteFrost;
  Color mainColor = CoreColors.toryBlue;
  IconData stateIcon = Icons.info_outline;

  switch (messageType) {
    case CoreScaffoldMessengerType.success:
      backgroundColor = CoreColors.hintOfGreen;
      mainColor = CoreColors.shareGreen;
      stateIcon = Icons.check;
      break;

    case CoreScaffoldMessengerType.error:
      mainColor = CoreColors.cadmiumRed;
      backgroundColor = CoreColors.forgotMeNot;
      stateIcon = Icons.cancel_outlined;
      break;

    case CoreScaffoldMessengerType.warning:
      backgroundColor = CoreColors.earlyDawn;
      mainColor = CoreColors.fuelYellow;
      stateIcon = Icons.warning_amber;
      break;

    case CoreScaffoldMessengerType.information:
      backgroundColor = CoreColors.whiteFrost;
      mainColor = CoreColors.toryBlue;
      stateIcon = Icons.info_outline;
      break;
  }

  globalScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: mainColor, width: 0.4),
      ),
      content: Row(
        children: [
          Icon(stateIcon, color: mainColor),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              content,
              style: TextStyle(fontSize: 14, color: mainColor),
            ),
          ),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
  return;
}
