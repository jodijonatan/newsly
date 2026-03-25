import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import '../providers/news_provider.dart';
import 'widgets/futuristic_card.dart';
import 'widgets/news_shimmer.dart';
import 'bookmarks_page.dart';
import 'settings_page.dart';
import '../theme/app_theme.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService client = ApiService();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "General";
  int _currentIndex = 0;
  bool _isSearching = false;

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() => _isSearching = false);
    } else {
      setState(() => _isSearching = true);
    }
  }

  final List<String> _categories = [
    "General",
    "Technology",
    "Business",
    "Sports",
    "Health",
    "Science",
    "Entertainment",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              _buildMainContent(),
              _buildExploreContent(),
              const BookmarksPage(),
              const SettingsPage(),
            ],
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildExploreContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        _buildSectionTitle("Explore Categories"),
        _buildCategoryChips(),
        _buildVerticalFeed(),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        _buildHeroSection(),
        _buildCategoryChips(),
        _buildSectionTitle("Quick Reads"),
        _buildQuickReads(),
        _buildSectionTitle("For You"),
        _buildVerticalFeed(),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: AppColors.textHigh),
              decoration: const InputDecoration(
                hintText: "Search news...",
                hintStyle: TextStyle(color: AppColors.textLow),
                border: InputBorder.none,
              ),
              onChanged: _onSearch,
              onSubmitted: _onSearch,
            )
          : Text(
              "Newsly.",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 24,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: AppColors.primaryGradient,
                      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
            ),
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close_rounded : Icons.search_rounded,
            color: AppColors.textHigh,
          ),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _searchController.clear();
                _isSearching = false;
              } else {
                _isSearching = true;
              }
            });
          },
        ),
        if (!_isSearching)
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.cardDark,
            child: Icon(Icons.person_outline, size: 20, color: AppColors.neonCyan),
          ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<Article>>(
        future: client.getNews(category: "general"),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const NewsShimmer();
          }
          return FuturisticCard(
            article: snapshot.data![0],
            isLarge: true,
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1);
        },
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final isSelected = _selectedCategory == _categories[index];
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = _categories[index]),
              child: AnimatedContainer(
                duration: 300.ms,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(colors: AppColors.primaryGradient)
                      : null,
                  color: isSelected ? null : AppColors.cardDark,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryGradient[0].withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textMed,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
            ),
            const Spacer(),
            Text(
              "See All",
              style: TextStyle(
                color: AppColors.neonCyan,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReads() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 180,
        child: FutureBuilder<List<Article>>(
          future: client.getNews(category: "technology"),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 3,
                itemBuilder: (context, index) => Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data![index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: article.urlToImage != null
                        ? DecorationImage(
                            image: NetworkImage(article.urlToImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: AppColors.cardDark,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      article.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ).animate().fadeIn(delay: (index * 100).ms).scale(begin: const Offset(0.9, 0.9));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildVerticalFeed() {
    return FutureBuilder<List<Article>>(
      future: client.getNews(
        query: _isSearching ? _searchController.text : "",
        category: _isSearching ? "" : _selectedCategory.toLowerCase(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const NewsShimmer(),
              childCount: 3,
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => FuturisticCard(article: snapshot.data![index]),
            childCount: snapshot.data!.length,
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 70,
        borderRadius: 35,
        blur: 20,
        alignment: Alignment.center,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_rounded, 0),
            _navItem(Icons.grid_view_rounded, 1),
            _navItem(Icons.bookmarks_rounded, 2),
            _navItem(Icons.settings_rounded, 3),
          ],
        ),
      ),
    ).animate().slideY(begin: 1, duration: 800.ms, curve: Curves.easeOutBack);
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.neonCyan : AppColors.textLow,
            size: isSelected ? 30 : 24,
          ).animate(target: isSelected ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.neonCyan,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.neonCyan, blurRadius: 8, spreadRadius: 2),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
