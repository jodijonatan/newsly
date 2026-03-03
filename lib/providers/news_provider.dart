import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/news_model.dart';

class NewsProvider with ChangeNotifier {
  static const String bookmarkBoxName = 'bookmarks';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  List<Article> get bookmarks {
    final box = Hive.box<Article>(bookmarkBoxName);
    return box.values.toList();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  bool isBookmarked(String url) {
    final box = Hive.box<Article>(bookmarkBoxName);
    return box.values.any((article) => article.url == url);
  }

  Future<void> toggleBookmark(Article article) async {
    final box = Hive.box<Article>(bookmarkBoxName);
    
    if (isBookmarked(article.url)) {
      // Find the key for the article with the same URL
      final key = box.keys.firstWhere(
        (k) => box.get(k)?.url == article.url,
        orElse: () => null,
      );
      if (key != null) {
        await box.delete(key);
      }
    } else {
      await box.add(article);
    }
    notifyListeners();
  }
}
