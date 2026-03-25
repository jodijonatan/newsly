import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/news_provider.dart';
import 'widgets/futuristic_card.dart';
import '../theme/app_theme.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final bookmarks = newsProvider.bookmarks;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghapus back button karena sekarang Tab
        title: Text(
          "SAVED STORIES",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 18,
                letterSpacing: 2,
              ),
        ),
      ),
      body: bookmarks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.bookmark_border_rounded, size: 80, color: AppColors.textLow),
                  const SizedBox(height: 24),
                  Text(
                    "Vault is empty",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHigh,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Stories you encrypt for later\nwill appear in this terminal.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMed, height: 1.5),
                  ),
                ],
              ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 40),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) =>
                  FuturisticCard(article: bookmarks[index]),
            ),
    );
  }
}
