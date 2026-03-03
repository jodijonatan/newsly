import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import '../providers/news_provider.dart';
import 'widgets/news_card.dart';
import '../views/widgets/news_shimmer.dart';
import 'bookmarks_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService client = ApiService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = "";

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
    final newsProvider = Provider.of<NewsProvider>(context);

    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: true,
                centerTitle: false,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                elevation: innerBoxIsScrolled ? 0.5 : 0,
                title: Text(
                  "Newsly.",
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      newsProvider.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                    onPressed: () => newsProvider.toggleTheme(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.bookmarks_rounded,
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookmarksPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(110),
                  child: Column(
                    children: [
                      // Modern Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: newsProvider.isDarkMode
                                ? Colors.grey[900]
                                : const Color(0xFFF1F3F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                              color: newsProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Search news, topics...",
                              hintStyle: TextStyle(
                                color: newsProvider.isDarkMode
                                    ? Colors.grey[500]
                                    : Colors.grey,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: newsProvider.isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.black54,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Custom Tab Bar
                      TabBar(
                        isScrollable: true,
                        indicatorColor: Colors.blueAccent,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.blueAccent,
                        unselectedLabelColor: newsProvider.isDarkMode
                            ? Colors.grey[500]
                            : Colors.grey[500],
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        tabs: _categories.map((c) => Tab(text: c)).toList(),
                        onTap: (index) {
                          setState(() {
                            _searchQuery = "";
                            _searchController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: _categories.map((cat) {
              return FutureBuilder<List<Article>>(
                future: _searchQuery.isNotEmpty
                    ? client.getNews(query: _searchQuery)
                    : client.getNews(category: cat.toLowerCase()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 5, // Tampilkan 5 kartu skeleton saat loading
                      padding: const EdgeInsets.only(top: 8),
                      itemBuilder: (context, index) => const NewsShimmer(),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) =>
                          NewsCard(article: snapshot.data![index]),
                    );
                  }

                  return _buildEmptyState();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No news found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try a different keyword or category",
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
