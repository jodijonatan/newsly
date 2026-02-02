import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_model.dart';

class ApiService {
  String get apiKey => dotenv.get('API_KEY', fallback: '');
  // Pastikan BASE_URL di .env adalah: https://newsapi.org/v2
  String get baseUrl =>
      dotenv.get('BASE_URL', fallback: 'https://newsapi.org/v2');

  Future<List<Article>> getNews({
    String category = 'general',
    String query = '',
  }) async {
    String url = "";

    // Logika: Jika ada query, gunakan /everything. Jika tidak, gunakan /top-headlines
    if (query.trim().isNotEmpty) {
      url =
          "$baseUrl/everything?q=${Uri.encodeComponent(query)}&apiKey=$apiKey";
    } else {
      // Pastikan category tidak kosong untuk top-headlines
      String cat = category.isEmpty ? 'general' : category;
      url = "$baseUrl/top-headlines?country=us&category=$cat&apiKey=$apiKey";
    }

    print("Fetching URL: $url"); // Untuk memantau di Debug Console

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['articles'] ?? [];
        return body.map((item) => Article.fromJson(item)).toList();
      } else {
        print("Server Error: ${response.body}");
        throw ("Gagal mengambil data: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
      throw ("Terjadi kesalahan koneksi");
    }
  }
}
