import 'package:chapter/utility/navigation/go_config.dart';
import 'package:flutter/material.dart';

coreLoadingDialog({
  required BuildContext context,
  required String content,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        alignment: Alignment.center,
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300), // Set a max width
          child: Row(
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Flexible(
                child: Text(content),
              ),
            ],
          ),
        ),
      );
    },
  );
}

coreCloseDialog() {
  goConfig.pop();
}
