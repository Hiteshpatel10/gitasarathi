import 'package:chapter/auth_module/views/sign_in_view.dart';
import 'package:chapter/chapter_module/views/chapter_verse_list_view.dart';
import 'package:chapter/home_module/view/challenge_celebration_view.dart';
import 'package:chapter/home_module/view/home_view.dart';
import 'package:chapter/home_module/view/language_and_author_selection_view.dart';
import 'package:chapter/home_module/view/onboarding_view.dart';
import 'package:chapter/home_module/view/streak_celebration_view.dart';
import 'package:chapter/main.dart';
import 'package:chapter/user_module/view/user_profile_view.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:chapter/verse_module/views/verse_explanation_view.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  navigatorKey: globalNavigatorKey,
  initialLocation: getInitialRoute(),
  routes: [
    GoRoute(
      path: AppRoutes.onBoarding.path,
      name: AppRoutes.onBoarding.name,
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: AppRoutes.signIn.path,
      name: AppRoutes.signIn.name,
      builder: (context, state) => const SignInView(),
    ),
    GoRoute(
      path: AppRoutes.languageAndAuthor.path,
      name: AppRoutes.languageAndAuthor.name,
      builder: (context, state) {
        final editMode = (state.uri.queryParameters['edit_mode'] ?? 'false') == 'true';
        final redirectPath = state.uri.queryParameters['redirect'];
        return LanguageAndAuthorSelectionView(
          editMode: editMode,
          redirectPath: redirectPath != null ? Uri.decodeComponent(redirectPath) : null,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.chaptersVerse.path,
      name: AppRoutes.chaptersVerse.name,
      builder: (context, state) {
        final chapterNo = int.tryParse(state.pathParameters['chapterNo'] ?? '1') ?? 1;
        return ChapterVerseListView(chapterNo: chapterNo);
      },
    ),
    GoRoute(
      path: AppRoutes.verseExplanation.path,
      name: AppRoutes.verseExplanation.name,
      redirect: (context, state) {
        final authId = prefs.getInt(AppPrefKeys.authorId);
        final langId = prefs.getInt(AppPrefKeys.languageId);

        if (authId == null || langId == null) {
          final redirectUrl = Uri.encodeComponent(state.uri.toString());
          return '${AppRoutes.languageAndAuthor.path}?redirect=$redirectUrl';
        }
        return null;
      },
      builder: (context, state) {
        final verseId = int.tryParse(state.pathParameters['verseId'] ?? '1') ?? 1;
        return VerseExplanationView(verseId: verseId);
      },
    ),
    GoRoute(
      path: AppRoutes.profile.path,
      name: AppRoutes.profile.name,
      builder: (context, state) {
        return const UserProfileView();
      },
    ),
    GoRoute(
      path: AppRoutes.streakCelebration.path,
      name: AppRoutes.streakCelebration.name,
      builder: (context, state) {
        final returnTo = state.uri.queryParameters['returnTo'];
        final currentStreak = num.parse(state.pathParameters['currentStreak']!);

        return StreakCelebrationView(returnTo: returnTo, currentStreak: currentStreak);
      },
    ),
    GoRoute(
      path: AppRoutes.challengeCelebration.path,
      name: AppRoutes.challengeCelebration.name,
      builder: (context, state) {
        final returnTo = state.uri.queryParameters['returnTo'];

        return ChallengeCelebrationView(returnTo: returnTo);
      },
    ),
  ],
);

String getInitialRoute() {
  final token = prefs.getString(AppPrefKeys.token);

  final isLoggedIn = token?.isNotEmpty ?? false;
  if (!isLoggedIn) {
    return AppRoutes.onBoarding.path;
  } else {
    return AppRoutes.home.path;
  }
}
