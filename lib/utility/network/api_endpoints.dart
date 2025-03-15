class ApiEndpoints {
  static const baseURL = "https://gitasarathi.geekaid.in/";
  static const s3BaseURL = "https://gita-path.s3.ap-south-1.amazonaws.com/chapter-images/";
  static chapter({required int chapterNo}) => "gita/chapter/$chapterNo";
  static verse({required int chapterNo, required int verseNo}) => "gita/verse/BG$chapterNo.$verseNo";


  static const authentication = "authentication";
  static const chaptersAndVerses = "chaptersAndVerses";
  static const languageAndAuthors = "languageAndAuthors";
  static const verseExplanation = "verseExplanation";







  static const user = "gita/user";
  static const updateRead = "gita/updateRead";
  static const updateFCM = "gita/updateFCM";
  static const userActivity = "gita/getUserWeekActivity";
  static const updateUserActivity = "gita/updateUserActivity";

  static const snsCreate = "gita/snsCreate";
  static const snsUpdate = "gita/snsUpdate";
}
