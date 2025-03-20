import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/constants/asset_paths.dart';
import 'package:chapter/utility/model/key_value_pair_model.dart';

import 'package:flutter/material.dart';

enum AppErrorCode {
  // noContent, // 000
  // notFound, // 404
  serverError, // 500
  // empty, // 204
  // startSIPServerError, // 204
}

class AppErrorWidget extends StatefulWidget {
  const AppErrorWidget({
    super.key,
    this.title,
    this.subtitle,
    required this.errorCode,
    this.image,
    this.padding,
  });
  final String? title;
  final String? subtitle;
  final String? image;
  final AppErrorCode errorCode;
  final EdgeInsets? padding;

  @override
  State<AppErrorWidget> createState() => _CoreErrorUtilsState();
}

class _CoreErrorUtilsState extends State<AppErrorWidget> {
  late KeyValuePairModel<String, String, String?> _errorInfo;

  @override
  void initState() {
    super.initState();
    _errorInfo = _getErrorInfo(widget.errorCode);
  }

  KeyValuePairModel<String, String, String?> _getErrorInfo(AppErrorCode errorCode) {
    switch (errorCode) {
      case AppErrorCode.serverError:
        return KeyValuePairModel(
          key: AssetPaths.serverErrorPNG,
          value: 'Server Error',
          extra: 'Something went wrong on our side',
        );
      // case CoreErrorCode.notFound:
      //   return KeyValuePairModel(
      //     key: CoreAssetPaths.notFoundPNG,
      //     value: 'The resource you are looking for could not be found.',
      //   );
      // case CoreErrorCode.serverError:
      //   return KeyValuePairModel(
      //     key: CoreAssetPaths.serverErrorPNG,
      //     value: 'Something went wrong on our end.',
      //   );
      // case CoreErrorCode.empty:
      //   return KeyValuePairModel(
      //     key: CoreAssetPaths.emptyPNG,
      //     value: 'There is no content available.',
      //   );
      default:
        return KeyValuePairModel(
          key: AssetPaths.serverErrorPNG,
          value: 'An unknown error occurred.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.image ?? _errorInfo.key,
              width: 220,
            ),
            const SizedBox(height: 8),
            Text(
              widget.title ?? _errorInfo.value,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
            ),
            if (_errorInfo.extra != null || widget.subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.subtitle ?? _errorInfo.extra!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
