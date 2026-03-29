import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import 'widgets/futuristic_card.dart';
import 'widgets/news_shimmer.dart';
import 'bookmarks_page.dart';
import 'settings_page.dart';
import '../theme/app_theme.dart';
import 'news_detail_page.dart';

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

  // Cached futures to prevent re-fetching on every setState
  late Future<List<Article>> _heroFuture;
  late Future<List<Article>> _quickReadsFuture;
  late Future<List<Article>> _feedFuture;

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
  void initState() {
    super.initState();
    _heroFuture = client.getNews(category: "general");
    _quickReadsFuture = client.getNews(category: "technology");
    _feedFuture = client.getNews(category: _selectedCategory.toLowerCase());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _isSearching = false;
      _searchController.clear();
      _feedFuture = client.getNews(category: category.toLowerCase());
    });
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _feedFuture =
            client.getNews(category: _selectedCategory.toLowerCase());
      });
    } else {
      setState(() {
        _isSearching = true;
        _feedFuture = client.getNews(query: query);
      });
    }
  }

  void _refreshAll() {
    setState(() {
      _heroFuture = client.getNews(category: "general");
      _quickReadsFuture = client.getNews(category: "technology");
      _feedFuture = client.getNews(
        query: _isSearching ? _searchController.text : "",
        category: _isSearching ? "" : _selectedCategory.toLowerCase(),
      );
    });
  }

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
    return RefreshIndicator(
      color: AppColors.neonCyan,
      backgroundColor: AppColors.cardDark,
      onRefresh: () async => _refreshAll(),
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildSectionTitle("Explore Categories"),
          _buildCategoryChips(),
          _buildVerticalFeed(),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      color: AppColors.neonCyan,
      backgroundColor: AppColors.cardDark,
      onRefresh: () async => _refreshAll(),
      child: CustomScrollView(
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
      ),
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
              onSubmitted: _onSearch,
            )
          : Text(
              "Newsly.",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 24,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: AppColors.primaryGradient,
                      ).createShader(
                          const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
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
                _feedFuture = client.getNews(
                    category: _selectedCategory.toLowerCase());
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
            child: Icon(Icons.person_outline,
                size: 20, color: AppColors.neonCyan),
          ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<Article>>(
        future: _heroFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorWidget(
              "Gagal memuat berita utama",
              onRetry: () =>
                  setState(() => _heroFuture = client.getNews(category: "general")),
            );
          }
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
              onTap: () => _onCategoryChanged(_categories[index]),
              child: AnimatedContainer(
                duration: 300.ms,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: AppColors.primaryGradient)
                      : null,
                  color: isSelected ? null : AppColors.cardDark,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                AppColors.primaryGradient[0].withOpacity(0.4),
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
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
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
            const Text(
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
          future: _quickReadsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Gagal memuat Quick Reads",
                  style: TextStyle(color: AppColors.textMed),
                ),
              );
            }
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
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          NewsDetailPage(article: article),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                            opacity: animation, child: child);
                      },
                    ),
                  ),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: article.urlToImage != null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                  article.urlToImage!),
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
                  ).animate()
                      .fadeIn(delay: (index * 100).ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildVerticalFeed() {
    return FutureBuilder<List<Article>>(
      future: _feedFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: _buildErrorWidget(
              "Gagal memuat berita",
              onRetry: () {
                setState(() {
                  _feedFuture = client.getNews(
                    query: _isSearching ? _searchController.text : "",
                    category:
                        _isSearching ? "" : _selectedCategory.toLowerCase(),
                  );
                });
              },
            ),
          );
        }
        if (!snapshot.hasData) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const NewsShimmer(),
              childCount: 3,
            ),
          );
        }
        if (snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildEmptyWidget(
              _isSearching
                  ? "Tidak ada hasil untuk \"${_searchController.text}\""
                  : "Tidak ada berita untuk kategori ini",
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                FuturisticCard(article: snapshot.data![index]),
            childCount: snapshot.data!.length,
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String message, {VoidCallback? onRetry}) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
                color: AppColors.textHigh, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded,
                  color: AppColors.neonCyan, size: 18),
              label: const Text("Coba Lagi",
                  style: TextStyle(color: AppColors.neonCyan)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.neonCyan),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String message) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: AppColors.textLow),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: AppColors.textMed, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
          )
              .animate(target: isSelected ? 1 : 0)
              .scale(
                  begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.neonCyan,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.neonCyan,
                      blurRadius: 8,
                      spreadRadius: 2),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
