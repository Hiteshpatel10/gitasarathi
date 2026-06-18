import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:chapter/user_module/cubit/user_cubit.dart';
import 'package:chapter/utility/messengers/core_scaffold_messenger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:chapter/main.dart';

class DeepLinkService {
  DeepLinkService._();
  static final instance = DeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<void> initDeepLinks(BuildContext context) async {
    // Handle initial link
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _navigateToDeepLink(context, initialLink);
        });
      }
    } catch (e) {
      logger.e("DeepLink - $e");
    }

    // Listen for incoming links
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _navigateToDeepLink(context, uri);
        });
      }
    }, onError: (err) {
      logger.e("DeepLink stream error - $err");
    });
  }

  void _navigateToDeepLink(BuildContext context, Uri uri) {
    if (uri.pathSegments.isEmpty) {
      coreMessenger("Invalid path");
      return;
    }

    final firstSegment = uri.pathSegments.first;
    const activity = "Deep Link Open";

    switch (firstSegment) {
      case "chapters":
        final chapterId = int.tryParse(uri.pathSegments.length > 1 ? uri.pathSegments[1] : "");
        if (chapterId != null) {
          GoRouter.of(context).push(uri.path);
          BlocProvider.of<UserCubit>(context).insertUserActivity(
            activity: activity,
            chapterId: chapterId,
          );
        } else {
          coreMessenger("Invalid chapter number");
        }
        break;

      case "verse":
        final verseId = int.tryParse(uri.pathSegments.length > 1 ? uri.pathSegments[1] : "");
        if (verseId != null) {
          GoRouter.of(context).push(uri.path);
          BlocProvider.of<UserCubit>(context).insertUserActivity(
            activity: activity,
            verseId: verseId,
          );
        } else {
          coreMessenger("Invalid verse number");
        }
        break;

      default:
        BlocProvider.of<UserCubit>(context).insertUserActivity(activity: activity);
        coreMessenger("Invalid path");
        break;
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
