enum AppRoutes {
  // Shell routes (Tabs)
  home(path: '/home'),
  chapters(path: '/chapters'),
  listen(path: '/listen'),
  bookmarks(path: '/bookmarks'),
  profile(path: '/profile'),

  // Auth routes
  login(path: '/login'),

  // Nested routes
  verseList(path: 'verse-list/:chapterId'),
  verseExplanation(path: 'verse-explanation/:verseId');

  const AppRoutes({required this.path});
  final String path;

  static const initialLocation = '/home';
}
