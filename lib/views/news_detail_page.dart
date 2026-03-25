import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/news_model.dart';
import '../providers/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailPage extends StatefulWidget {
  final Article article;

  const NewsDetailPage({super.key, required this.article});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool _isListening = false;
  String? _aiSummary;
  String? _aiExplanation;
  String _sentiment = "NEUTRAL";
  bool _isLoadingAI = true;
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _initTTS();
    _fetchAIData();
  }

  void _initTTS() {
    _flutterTts = FlutterTts();
    _flutterTts.setCompletionHandler(() {
      setState(() => _isListening = false);
    });
  }

  Future<void> _fetchAIData() async {
    try {
      final textToAnalyze = "${widget.article.title} ${widget.article.description ?? ''} ${widget.article.content ?? ''}";
      
      final results = await Future.wait([
        GeminiService.getSummary(textToAnalyze),
        GeminiService.getSimplifiedExplanation(textToAnalyze),
        GeminiService.analyzeSentiment(widget.article.title),
      ]);

      if (mounted) {
        setState(() {
          _aiSummary = results[0];
          _aiExplanation = results[1];
          _sentiment = results[2];
          _isLoadingAI = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingAI = false);
      }
    }
  }

  void _toggleTTS() async {
    if (_isListening) {
      await _flutterTts.stop();
    } else {
      final textToRead = "${widget.article.title}. ${widget.article.description ?? ''}. ${widget.article.content ?? ''}";
      await _flutterTts.speak(textToRead);
    }
    setState(() => _isListening = !_isListening);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final isBookmarked = newsProvider.isBookmarked(widget.article.url);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeader(),
              _buildContent(),
              _buildAISummary(),
              _buildExplainSimply(),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _buildFloatingActions(isBookmarked, newsProvider),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: AppColors.darkBg,
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.black26,
          child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            widget.article.urlToImage != null
                ? CachedNetworkImage(
                    imageUrl: widget.article.urlToImage!,
                    fit: BoxFit.cover,
                  )
                : Container(color: AppColors.cardDark),
            // Multi-layered gradient for depth
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    AppColors.darkBg.withOpacity(0.8),
                    AppColors.darkBg,
                  ],
                  stops: const [0, 0.3, 0.8, 1.0],
                ),
              ),
            ),
            // Title over header
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSentimentBadge(),
                  const SizedBox(height: 12),
                  Text(
                    widget.article.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                          height: 1.2,
                        ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
                ],
              ),
            ),
          ],
        ),
        stretchModes: const [StretchMode.zoomBackground],
      ),
    );
  }

  Widget _buildContent() {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.source_outlined, size: 16, color: AppColors.neonCyan),
                const SizedBox(width: 8),
                Text(
                  widget.article.sourceName ?? "Unknown Source",
                  style: const TextStyle(
                    color: AppColors.neonCyan,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.access_time, size: 16, color: AppColors.textLow),
                const SizedBox(width: 4),
                Text(
                  "2 hours ago",
                  style: TextStyle(color: AppColors.textLow, fontSize: 12),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 24),
            Text(
              widget.article.description ?? "",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHigh,
                  ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 16),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textMed,
                    height: 1.8,
                  ),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildAISummary() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 220,
          borderRadius: 24,
          blur: 20,
          alignment: Alignment.center,
          border: 1,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.neonPurple.withOpacity(0.1),
              AppColors.neonCyan.withOpacity(0.05),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.neonPurple.withOpacity(0.5),
              AppColors.neonCyan.withOpacity(0.5),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "AI SUMMARY",
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.amber,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    if (_isLoadingAI)
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _aiSummary ?? (_isLoadingAI ? "Analyzing article..." : "AI Summary not available."),
                      style: TextStyle(
                        color: AppColors.textHigh,
                        height: 1.6,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 700.ms).custom(
              builder: (context, value, child) => Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            ),
      ),
    );
  }

  Widget _buildExplainSimply() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explain Simply",
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textHigh,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _aiExplanation ?? (_isLoadingAI ? "Simplifying..." : "Full article required for deep analysis."),
              style: TextStyle(color: AppColors.textMed, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentBadge() {
    Color badgeColor;
    IconData badgeIcon;
    
    switch (_sentiment) {
      case "POSITIVE":
        badgeColor = AppColors.positive;
        badgeIcon = Icons.trending_up;
        break;
      case "NEGATIVE":
        badgeColor = Colors.redAccent;
        badgeIcon = Icons.trending_down;
        break;
      default:
        badgeColor = AppColors.neonCyan;
        badgeIcon = Icons.trending_flat;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, color: badgeColor, size: 14),
          const SizedBox(width: 6),
          Text(
            "$_sentiment SENTIMENT",
            style: TextStyle(
              color: badgeColor,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions(bool isBookmarked, NewsProvider newsProvider) {
    return Positioned(
      bottom: 30,
      left: 30,
      right: 30,
      child: Center(
        child: GlassmorphicContainer(
          width: 250,
          height: 60,
          borderRadius: 30,
          blur: 20,
          alignment: Alignment.center,
          border: 1,
          linearGradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
          ),
          borderGradient: const LinearGradient(
            colors: AppColors.primaryGradient,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                  color: isBookmarked ? AppColors.neonCyan : Colors.white,
                ),
                onPressed: () => newsProvider.toggleBookmark(widget.article),
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                onPressed: () {
                  Share.share("${widget.article.title}\n${widget.article.url}");
                },
              ),
              IconButton(
                icon: Icon(
                  _isListening ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: AppColors.neonPurple,
                  size: 32,
                ),
                onPressed: _toggleTTS,
              ),
            ],
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, duration: 800.ms, curve: Curves.easeOutBack);
  }
}
