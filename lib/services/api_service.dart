import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class ApiService {
  final String apiKey = "6dec5f74fc264a138d600bd1e3074c86";
  final String baseUrl = "https://newsapi.org/v2/everything?q=tesla&apiKey=";

  Future<List<Article>> getNews() async {
    final response = await http.get(Uri.parse(baseUrl + apiKey));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];
      return body.map((item) => Article.fromJson(item)).toList();
    } else {
      throw ("Gagal mengambil data berita");
    }
  }
}
