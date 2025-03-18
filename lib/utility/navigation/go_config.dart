import 'package:chapter/auth_module/views/sign_in_view.dart';
import 'package:chapter/chapter_module/views/chapter_verse_list_view.dart';
import 'package:chapter/home_module/cubit/onboarding_cubit.dart';
import 'package:chapter/home_module/view/home_view.dart';
import 'package:chapter/home_module/view/language_and_author_selection_view.dart';
import 'package:chapter/home_module/view/onboarding_view.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:chapter/verse_module/views/verse_explanation_view.dart';
import 'package:go_router/go_router.dart';

final goConfig = GoRouter(
  navigatorKey: globalNavigatorKey,
  initialLocation: getInitialRoute(),
  routes: [
    GoRoute(
      path: AppRoutes.onBoarding,
      name: AppRoutes.onBoarding,
      builder: (context, state) {
        return const OnboardingView();
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) {
        return const HomeView();
      },
    ),
    GoRoute(
      path: AppRoutes.signIn,
      name: AppRoutes.signIn,
      builder: (context, state) {
        return const SignInView();
      },
    ),
    GoRoute(
      path: AppRoutes.languageAndAuthor,
      name: AppRoutes.languageAndAuthor,
      builder: (context, state) {
        return const LanguageAndAuthorSelectionView();
      },
    ),
    GoRoute(
      path: AppRoutes.chaptersVerse,
      name: AppRoutes.chaptersVerse,
      builder: (context, state) {
        final arguments = state.extra as Map<String, dynamic>?;
        final chapterNo = arguments?["chapter_no"] as int? ?? 1;
        return ChapterVerseListView(chapterNo: chapterNo);
      },
    ),
    GoRoute(
      path: AppRoutes.verseExplanation,
      name: AppRoutes.verseExplanation,
      builder: (context, state) {
        final arguments = state.extra as Map<String, dynamic>?;
        final verseId = arguments?["verse_id"] as int? ?? 1;
        return VerseExplanationView(verseId: verseId);
      },
    ),
  ],
);

String getInitialRoute() {
  final token = prefs.getString(AppPrefKeys.token);
  final authId = prefs.getInt(AppPrefKeys.authorId);
  final langId = prefs.getInt(AppPrefKeys.languageId);
  final isLoggedIn = token?.isNotEmpty == true;
  // final isFirstTimeUser = prefs.getBool(AppPrefKeys.isFirstTimeUser) ?? true;
  // final hasProfileSetup = prefs.getBool(AppPrefKeys.hasProfileSetup) ?? false;

  if (!isLoggedIn) {
    return AppRoutes.onBoarding; // User not logged in, navigate to Sign In
  } else if (authId == null || langId == null) {
    return AppRoutes.languageAndAuthor; // First-time user, go to onboarding
  } else {
    return AppRoutes.home; // Default to Home
  }
}
