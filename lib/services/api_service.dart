import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import package
import '../models/news_model.dart';

class ApiService {
  // Mengambil nilai langsung dari file .env
  String get apiKey => dotenv.get('API_KEY', fallback: '');
  String get baseUrl => dotenv.get('BASE_URL', fallback: '');

  Future<List<Article>> getNews() async {
    // Menyusun URL menggunakan variabel dari .env
    // Kita tambahkan query parameter secara dinamis
    final String fullUrl = "$baseUrl?q=tesla&apiKey=$apiKey";

    try {
      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['articles'];
        return body.map((item) => Article.fromJson(item)).toList();
      } else {
        throw ("Gagal mengambil data berita: ${response.statusCode}");
      }
    } catch (e) {
      throw ("Terjadi kesalahan: $e");
    }
  }
}
