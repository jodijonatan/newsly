import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_model.dart';

/// Custom exception for API errors with status code context.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  String get apiKey => dotenv.get('API_KEY', fallback: '');
  String get baseUrl =>
      dotenv.get('BASE_URL', fallback: 'https://newsapi.org/v2');

  Future<List<Article>> getNews({
    String category = 'general',
    String query = '',
  }) async {
    String url;

    if (query.trim().isNotEmpty) {
      url = "$baseUrl/everything?q=${Uri.encodeComponent(query)}";
    } else {
      String cat = category.isEmpty ? 'general' : category;
      url = "$baseUrl/top-headlines?country=us&category=$cat";
    }

    if (kDebugMode) {
      debugPrint("Fetching URL: $url");
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'X-Api-Key': apiKey},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['articles'] ?? [];
        return body.map((item) => Article.fromJson(item)).toList();
      } else {
        throw ApiException(
          "Gagal mengambil data",
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException("Terjadi kesalahan koneksi: $e");
    }
  }
}
