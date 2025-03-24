import 'dart:async';
import 'package:chapter/main.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/user_module/cubit/user_cubit.dart';
import 'package:chapter/user_module/view/user_activity_view.dart';
import 'package:chapter/utility/messengers/core_scaffold_messenger.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/utility/services/core_notification_service.dart';
import 'package:chapter/utility/services/rate_my_app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_links/uni_links.dart';
import 'package:chapter/chapter_module/views/chapter_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    _initDeepLinks();
    CoreNotificationService().updateFCMToken();
    CoreNotificationService().init().then((value) {
      CoreNotificationService().fcmListener();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateUs(context);
    });

    BlocProvider.of<UserCubit>(context).getUser();
    super.initState();
  }

  StreamSubscription? _sub;

  Future<void> _initDeepLinks() async {
    try {
      final String? link = await getInitialLink();
      if (link != null) {
        _navigateToDeepLink(link);
      }
    } catch (e) {
      logger.e("DeepLink - $e");
    }

    _sub = linkStream.listen((String? link) {
      if (link != null) {
        _navigateToDeepLink(link);
      }
    });
  }

  void _navigateToDeepLink(String link) {
    Uri uri = Uri.parse(link);

    if (uri.pathSegments.isNotEmpty) {
      String firstSegment = uri.pathSegments.first;

      if (firstSegment == "chapters" || firstSegment == "verse") {
        GoRouter.of(context).push(Uri.parse(link).path);
      } else {
        coreMessenger("Invalid path");
      }
    } else {
      coreMessenger("Invalid path");
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).pushNamed(AppRoutes.profile.name);
            },
            icon: const Icon(Icons.person, color: Colors.brown),
          )
        ],
      ),
      body: Column(
        children: [
          UserActivityView(),
        ],
      ),
      // body: const ChapterListView(),
    );
  }
}

