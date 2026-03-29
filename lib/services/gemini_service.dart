import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String _apiKey = dotenv.get('GEMINI_API_KEY', fallback: '');

  static final _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _apiKey,
  );

  // Simple in-memory cache to avoid redundant API calls
  static final Map<String, String> _cache = {};

  static Future<String> getSummary(String text) async {
    if (_apiKey.isEmpty) return "AI Summary not available (Missing API Key).";

    final cacheKey = 'summary_${text.hashCode}';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    try {
      // Truncate input to avoid sending overly long prompts
      final truncated = text.length > 2000 ? text.substring(0, 2000) : text;
      final prompt =
          "Summarize the following news article in 3-4 bullet points. Focus on key facts only:\n\n$truncated";
      final content = [Content.text(prompt)];
      final response = await _model
          .generateContent(content)
          .timeout(const Duration(seconds: 15));
      final result = response.text ?? "Summary could not be generated.";
      _cache[cacheKey] = result;
      return result;
    } on TimeoutException {
      return "AI Summary timed out. Please try again.";
    } on GenerativeAIException catch (e) {
      return "AI Error: ${e.message}";
    } catch (e) {
      return "AI unavailable. Please try again later.";
    }
  }

  static Future<String> getSimplifiedExplanation(String text) async {
    if (_apiKey.isEmpty) return "Explanation not available (Missing API Key).";

    final cacheKey = 'explain_${text.hashCode}';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    try {
      final truncated = text.length > 2000 ? text.substring(0, 2000) : text;
      final prompt =
          "Explain this news snippet simply, as if explaining to a 10-year old:\n\n$truncated";
      final content = [Content.text(prompt)];
      final response = await _model
          .generateContent(content)
          .timeout(const Duration(seconds: 15));
      final result = response.text ?? "Explanation could not be generated.";
      _cache[cacheKey] = result;
      return result;
    } on TimeoutException {
      return "Explanation timed out. Please try again.";
    } on GenerativeAIException catch (e) {
      return "AI Error: ${e.message}";
    } catch (e) {
      return "AI unavailable. Please try again later.";
    }
  }

  static Future<String> analyzeSentiment(String text) async {
    if (_apiKey.isEmpty) return "NEUTRAL";

    final cacheKey = 'sentiment_${text.hashCode}';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    try {
      final prompt =
          "Analyze the sentiment of this news title. Respond with ONLY one word: POSITIVE, NEGATIVE, or NEUTRAL.\n\n$text";
      final content = [Content.text(prompt)];
      final response = await _model
          .generateContent(content)
          .timeout(const Duration(seconds: 10));
      final raw = response.text?.trim().toUpperCase() ?? "NEUTRAL";
      // Validate the response is one of the expected values
      final result = ['POSITIVE', 'NEGATIVE', 'NEUTRAL'].contains(raw)
          ? raw
          : 'NEUTRAL';
      _cache[cacheKey] = result;
      return result;
    } catch (e) {
      return "NEUTRAL";
    }
  }
}
