const int wordsPerMinute = 25;

int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;

  final readingTime = wordCount / wordsPerMinute;

  return readingTime.ceil();
}
