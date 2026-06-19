import 'dart:async';
import 'package:chapter/challenges_module/view/challenge_view.dart';
import 'package:chapter/chapter_module/views/chapter_list_view.dart';
import 'package:chapter/favourite_module/view/favourites_view.dart';
import 'package:chapter/home_module/cubit/onboarding_cubit.dart';
import 'package:chapter/main.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/user_module/cubit/user_cubit.dart';
import 'package:chapter/user_module/view/user_activity_view.dart';
import 'package:chapter/user_module/view/user_profile_view.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:chapter/utility/services/core_deep_link_service.dart';
import 'package:chapter/utility/services/core_notification_service.dart';
import 'package:chapter/utility/services/rate_my_app_service.dart';
import 'package:chapter/utility/services/session_service.dart';
import 'package:chapter/verse_module/cubit/verse_explanation_cubit.dart';
import 'package:chapter/verse_module/model/verse_explanation_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentPageIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _currentPageIndex = kDebugMode ? 0 : 1;
    _pageController = PageController(initialPage: _currentPageIndex);

    DeepLinkService.instance.initDeepLinks(context);
    _initNotificationServices();
    SessionService().init();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateUs(context);
    });

    BlocProvider.of<OnboardingCubit>(context).getOnboarding(checkUpdate: true);
    BlocProvider.of<UserCubit>(context).insertUserActivity(activity: UserActivity.appOpen);
  }

  bool _hasLoadedUserData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoadedUserData) {
      _hasLoadedUserData = true;
      _initUserData();
    }
  }

  void _initNotificationServices() {
    final notificationService = CoreNotificationService();
    notificationService.updateFCMToken();
    notificationService.init().then((_) => notificationService.fcmListener());
    notificationService.setupInteractedMessage();
  }

  void _initUserData() async {
    final userCubit = BlocProvider.of<UserCubit>(context);
    final verseExplanationCubit = BlocProvider.of<VerseExplanationCubit>(context);

    userCubit.getUser();

    final lastReadVerseId = prefs.getInt(AppPrefKeys.lastReadVerseId);
    final canShowDrawer = prefs.getBool(AppPrefKeys.showContinueReading);

    if (lastReadVerseId != null && (canShowDrawer == null || canShowDrawer == true)) {
      final nextVerseId = lastReadVerseId + 1;
      if (nextVerseId > 701 || GoRouterState.of(context).matchedLocation != AppRoutes.home.path) {
        return;
      }
      await verseExplanationCubit.getVerseExplanation(verseId: nextVerseId);
      final verseState = verseExplanationCubit.state;
      if (verseState is VerseExplanationSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Future.delayed(
            Durations.long4,
            () => _showContinueReadingPrompt(verseState.verseExplanation),
          );
        });
      }
    }
  }

  void _showContinueReadingPrompt(VerseExplanationModel lastRead) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final cleanedText = lastRead.result?.text?.replaceAll('\n\n', '\n');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Continue Reading?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Next Read: Chapter ${lastRead.result?.chapterNumber}, Verse ${lastRead.result?.verseNumber}",
              ),
              const SizedBox(height: 8),
              Text(cleanedText ?? ''),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Not now"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: const Size(180, 48),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      GoRouter.of(context).pushNamed(
                        AppRoutes.verseExplanation.name,
                        pathParameters: {
                          "verseId": '${lastRead.result?.id}',
                        },
                      );
                    },
                    child: const Text("Continue"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    prefs.setBool(AppPrefKeys.showContinueReading, false);
                    GoRouter.of(context).pop();
                  },
                  child: Text(
                    "Don't remind me again",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _currentPageIndex = value;
          });
        },
        children: const [
          ChallengeView(),
          ChapterListView(),
          UserActivityView(),
          FavouritesView(),
          UserProfileView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(18),
          ),
        ),
        child: BottomNavigationBar(
          onTap: (value) {
            _pageController.jumpToPage(value);
          },
          currentIndex: _currentPageIndex,
          selectedItemColor: CoreColors.brown,
          unselectedItemColor: CoreColors.textGrey,
          selectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.golf_course_sharp),
              label: "Challenges",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department),
              label: "Streak",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favourite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
