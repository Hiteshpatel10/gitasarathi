import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/auth/view/login_screen.dart';
import 'package:app/features/home/view/home_screen.dart';
import 'package:app/features/bookmarks/view/bookmarks_screen.dart';
import 'package:app/features/chapters/view/verse_list_view.dart';
import 'package:app/features/chapters/view/verse_explanation_view.dart';
import 'package:app/features/profile/view/profile_screen.dart';
import 'package:app/core/services/pref_service.dart';
import 'package:app/core/constants/pref_keys.dart';

import 'app_routes.dart';
import 'route_destinations.dart';
import 'scaffold_with_nav_bar.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'tab_home');
final _chaptersNavKey = GlobalKey<NavigatorState>(debugLabel: 'tab_chapters');
final _listenNavKey = GlobalKey<NavigatorState>(debugLabel: 'tab_listen');
final _bookmarksNavKey = GlobalKey<NavigatorState>(debugLabel: 'tab_bookmarks');
final _profileNavKey = GlobalKey<NavigatorState>(debugLabel: 'tab_profile');

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.initialLocation,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final prefs = ref.read(prefServiceProvider);
      final token = prefs.getString(PrefKeys.userToken);
      final isLoggedIn = token != null && token.isNotEmpty;

      final isGoingToLogin = state.uri.path == AppRoutes.login.path;

      if (!isLoggedIn && !isGoingToLogin) {
        return AppRoutes.login.path;
      }

      if (isLoggedIn && isGoingToLogin) {
        return AppRoutes.home.path;
      }

      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavKey,
            routes: [
              GoRoute(
                name: AppRoutes.home.name,
                path: AppRoutes.home.path,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _chaptersNavKey,
            routes: [
              GoRoute(
                name: AppRoutes.chapters.name,
                path: AppRoutes.chapters.path,
                builder: (context, state) => ChaptersDestination.instance.build(context),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    name: AppRoutes.verseList.name,
                    path: AppRoutes.verseList.path,
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['chapterId']!);
                      return VerseListView(chapterId: id);
                    },
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        name: AppRoutes.verseExplanation.name,
                        path: AppRoutes.verseExplanation.path,
                        builder: (context, state) {
                          final verseId = int.parse(state.pathParameters['verseId']!);
                          return VerseExplanationView(verseId: verseId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _listenNavKey,
            routes: [
              GoRoute(
                name: AppRoutes.listen.name,
                path: AppRoutes.listen.path,
                builder: (context, state) => const _PlaceholderScreen('Listen'),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _bookmarksNavKey,
            routes: [
              GoRoute(
                name: AppRoutes.bookmarks.name,
                path: AppRoutes.bookmarks.path,
                builder: (context, state) => const BookmarksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavKey,
            routes: [
              GoRoute(
                name: AppRoutes.profile.name,
                path: AppRoutes.profile.path,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: AppRoutes.login.name,
        path: AppRoutes.login.path,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
