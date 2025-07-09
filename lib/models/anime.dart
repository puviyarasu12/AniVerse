import 'dart:convert';


class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final double score;
  final String synopsis;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
    required this.synopsis,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      imageUrl: json['images']?['jpg']?['image_url'] ?? 'https://via.placeholder.com/150',
      score: (json['score'] ?? 0).toDouble(),
      synopsis: json['synopsis'] ?? 'No synopsis available',
    );
  }
}

class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String source;
  final String author;
  final String content;

  const NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
    required this.author,
    required this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No description',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
      source: json['source']?['name'] ?? 'Unknown Source',
      author: json['author'] ?? 'Anonymous',
      content: json['content'] ?? 'No content available',
    );
  }
}
