class ApiEndpoints {
  ApiEndpoints._();

  // Use http://172.23.16.170:3000/ for physical device on the same Wi-Fi network
  static const String baseURL = "http://172.23.16.170:3000/";
  
  static const String authentication = "authentication";
  static const String user = "user";
  static const String lastActivity = "last-activity";
  static const String streakSummary = "streak-summary";
  static const String verseOfTheDay = "verse-of-the-day";
  static const String chapters = "chapters";
  static const String chaptersAndVerses = "chaptersAndVerses";
  static const String verseExplanation = "verseExplanation";
  static const String progress = "progress";
  static const String favoriteList = "favorite/list";
  static const String favoriteAdd = "favorite/add";
  static const String favoriteRemove = "favorite/remove";
}
