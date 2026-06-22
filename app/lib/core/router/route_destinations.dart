import 'package:flutter/material.dart';
import '../../features/chapters/view/chapters_screen.dart';
import 'app_routes.dart';

abstract class AppDestination {
  const AppDestination();

  String get name;
  Map<String, String> get pathParameters => const {};
  Map<String, dynamic> get queryParameters => const {};
  Object? get extra => null;
}

class HomeDestination extends AppDestination {
  const HomeDestination();
  @override
  String get name => AppRoutes.home.name;

  static const instance = HomeDestination();
}

class ChaptersDestination extends AppDestination {
  const ChaptersDestination();

  @override
  String get name => AppRoutes.chapters.name;

  Widget build(BuildContext context) {
    return const ChaptersScreen();
  }

  static const instance = ChaptersDestination();
}

class ListenDestination extends AppDestination {
  const ListenDestination();
  @override
  String get name => AppRoutes.listen.name;

  static const instance = ListenDestination();
}

class BookmarksDestination extends AppDestination {
  const BookmarksDestination();
  @override
  String get name => AppRoutes.bookmarks.name;

  static const instance = BookmarksDestination();
}

class ProfileDestination extends AppDestination {
  const ProfileDestination();
  @override
  String get name => AppRoutes.profile.name;

  static const instance = ProfileDestination();
}

class LoginDestination extends AppDestination {
  const LoginDestination();
  @override
  String get name => AppRoutes.login.name;

  static const instance = LoginDestination();
}

class VerseListDestination extends AppDestination {
  const VerseListDestination({required this.chapterId});
  
  final int chapterId;
  
  @override
  String get name => AppRoutes.verseList.name;

  @override
  Map<String, String> get pathParameters => {'chapterId': chapterId.toString()};
}
