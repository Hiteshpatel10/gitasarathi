import 'package:chapter/auth_module/views/sign_in_view.dart';
import 'package:chapter/chapter_module/views/chapter_detail_view.dart';
import 'package:chapter/chapter_module/views/chapters_view.dart';
import 'package:chapter/home_module/view/home_view.dart';
import 'package:chapter/home_module/view/language_and_author_selection_view.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:chapter/verse_module/views/verse_view.dart';
import 'package:go_router/go_router.dart';

final goConfig = GoRouter(
  initialLocation: getInitialRoute(),
  routes: [
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
      path: AppRoutes.chapters,
      name: AppRoutes.chapters,
      builder: (context, state) {
        return const ChaptersView();
      },
    ),
    GoRoute(
      path: AppRoutes.chapterDetail,
      name: AppRoutes.chapterDetail,
      builder: (context, state) {
        final arguments = state.extra as Map<String, dynamic>?;
        final chapterNo = arguments?["chapter_no"] as int? ?? 12;

        return ChapterDetailView(chapterNo: chapterNo);
      },
    ),
    GoRoute(
      path: AppRoutes.verse,
      name: AppRoutes.verse,
      builder: (context, state) {
        final arguments = state.extra as Map<String, dynamic>;

        final verseNo = arguments["verse_no"] as int;
        final chapterNo = arguments["chapter_no"] as int;
        return VerseView(chapterNo: chapterNo, verseNo: verseNo);
      },
    )
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
    return AppRoutes.signIn; // User not logged in, navigate to Sign In
  } else if (authId == null || langId == null) {
    return AppRoutes.languageAndAuthor; // First-time user, go to onboarding
  } else {
    return AppRoutes.home; // Default to Home
  }
}
