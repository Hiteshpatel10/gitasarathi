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

  // 🔹 List of all routes (optional, useful for debugging or generating route lists)
  static const List<AppRoute> allRoutes = [
    home,
    signIn,
    languageAndAuthor,
    chaptersVerse,
    verseExplanation,
    onBoarding,
  ];
}
