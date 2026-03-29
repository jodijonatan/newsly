import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/news_model.dart';

class NewsProvider with ChangeNotifier {
  static const String bookmarkBoxName = 'bookmarks';

  // Cached bookmark data for performance
  List<Article> _cachedBookmarks = [];
  Set<String> _bookmarkedUrls = {};

  NewsProvider() {
    _refreshBookmarkCache();
  }

  List<Article> get bookmarks => _cachedBookmarks;

  void _refreshBookmarkCache() {
    final box = Hive.box<Article>(bookmarkBoxName);
    _cachedBookmarks = box.values.toList();
    _bookmarkedUrls = _cachedBookmarks.map((a) => a.url).toSet();
  }

  // O(1) lookup instead of O(n) scan
  bool isBookmarked(String url) => _bookmarkedUrls.contains(url);

  Future<void> toggleBookmark(Article article) async {
    final box = Hive.box<Article>(bookmarkBoxName);

    if (isBookmarked(article.url)) {
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

    _refreshBookmarkCache();
    notifyListeners();
  }
}
