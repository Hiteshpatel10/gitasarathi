import 'package:chapter/auth_module/views/sign_in_view.dart';
import 'package:chapter/chapter_module/views/chapter_verse_list_view.dart';
import 'package:chapter/home_module/view/home_view.dart';
import 'package:chapter/home_module/view/language_and_author_selection_view.dart';
import 'package:chapter/home_module/view/onboarding_view.dart';
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
        return LanguageAndAuthorSelectionView(editMode: editMode);
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
  ],
);

String getInitialRoute() {
  final token = prefs.getString(AppPrefKeys.token);
  final authId = prefs.getInt(AppPrefKeys.authorId);
  final langId = prefs.getInt(AppPrefKeys.languageId);
  final isLoggedIn = token?.isNotEmpty ?? false;

  if (!isLoggedIn) {
    return AppRoutes.onBoarding.path;
  } else if (authId == null || langId == null) {
    return AppRoutes.languageAndAuthor.path;
  } else {
    return AppRoutes.home.path;
  }
}
