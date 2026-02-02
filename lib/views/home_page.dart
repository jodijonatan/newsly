import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import 'widgets/news_card.dart';
import '../views/widgets/news_shimmer.dart';

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
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        backgroundColor: const Color(
          0xFFF8F9FA,
        ), // Warna background sangat soft
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: true,
                centerTitle: false,
                backgroundColor: Colors.white,
                elevation: innerBoxIsScrolled ? 0.5 : 0,
                title: const Text(
                  "Newsly.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
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
                            color: const Color(0xFFF1F3F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Search news, topics...",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Colors.black54,
                              ),
                              contentPadding: EdgeInsets.symmetric(
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
                        unselectedLabelColor: Colors.grey[500],
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
