import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/news_model.dart';
import '../../theme/app_theme.dart';
import '../news_detail_page.dart';

class FuturisticCard extends StatelessWidget {
  final Article article;
  final bool isLarge;

  const FuturisticCard({
    super.key,
    required this.article,
    this.isLarge = false,
  });

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            NewsDetailPage(article: article),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        height: isLarge ? 300 : 200,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Stack(
          children: [
            // Background Image with Gradient
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  article.urlToImage != null
                      ? CachedNetworkImage(
                          imageUrl: article.urlToImage!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.cardDark,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.neonCyan,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.darkBg.withOpacity(0.8),
                          AppColors.darkBg,
                        ],
                        stops: const [0.4, 0.8, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Glassmorphism Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GlassmorphicContainer(
                width: double.infinity,
                height: 120,
                borderRadius: 24,
                blur: 20,
                alignment: Alignment.bottomCenter,
                border: 2,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.neonCyan.withOpacity(0.5),
                    AppColors.neonPurple.withOpacity(0.5),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Title
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textHigh,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                      
                      const SizedBox(height: 8),

                      // Metadata
                      Row(
                        children: [
                          _buildBadge(
                            article.sourceName ?? "Newsly",
                            AppColors.primaryGradient,
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: AppColors.textMed,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "5 min read",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMed,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 200.ms),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate().scale(
            begin: const Offset(0.95, 0.95),
            duration: 400.ms,
            curve: Curves.easeOutBack,
          ),
    );
  }

  Widget _buildBadge(String text, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.cardDark,
      child: const Center(
        child: Icon(Icons.article_outlined, size: 60, color: AppColors.textLow),
      ),
    );
  }
}
