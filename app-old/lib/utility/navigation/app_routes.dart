class AppRoute {
  final String name;
  final String path;

  const AppRoute(this.name, this.path);
}

class AppRoutes {
  static const home = AppRoute('home', '/');
  static const signIn = AppRoute('signIn', '/signIn');
  static const languageAndAuthor = AppRoute('languageAndAuthor', '/languageAndAuthor');
  static const chaptersVerse = AppRoute('chaptersVerse', '/chapters/:chapterNo');
  static const verseExplanation = AppRoute('verseExplanation', '/verse/:verseId');
  static const onBoarding = AppRoute('onBoarding', '/onBoarding');
  static const profile = AppRoute('profile', '/profile');
  static const streakCelebration = AppRoute(
    'streakCelebration',
    '/streakCelebration/:currentStreak',
  );
  static const challengeCelebration = AppRoute(
    'challengeCelebration',
    '/challengeCelebration',
  );
}
