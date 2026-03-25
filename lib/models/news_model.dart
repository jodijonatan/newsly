import 'package:hive/hive.dart';

part 'news_model.g.dart';

@HiveType(typeId: 0)
class Article extends HiveObject {
  @HiveField(0)
  final String title;
  
  @HiveField(1)
  final String? description;
  
  @HiveField(2)
  final String? urlToImage;
  
  @HiveField(3)
  final String url;
  
  @HiveField(4)
  final String? author;
  
  @HiveField(5)
  final String? publishedAt;
  
  @HiveField(6)
  final String? content;

  @HiveField(7)
  final String? sourceName;

  Article({
    required this.title,
    this.description,
    this.urlToImage,
    required this.url,
    this.author,
    this.publishedAt,
    this.content,
    this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'],
      urlToImage: json['urlToImage'],
      url: json['url'] ?? '',
      author: json['author'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      sourceName: json['source'] != null ? json['source']['name'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'url': url,
      'author': author,
      'publishedAt': publishedAt,
      'content': content,
      'sourceName': sourceName,
    };
  }
}
