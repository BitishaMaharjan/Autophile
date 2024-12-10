import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:autophile/models/car_news.dart';

class NewsService {
  final String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<dynamic>> fetchCarNewsFromAPI() async {
    final String url =
        'https://newsapi.org/v2/everything?q=cars&language=en&pageSize=10&page=1&apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['articles'] as List<dynamic>;
      } else {
        throw Exception('Failed to fetch news from API');
      }
    } catch (e) {
      throw Exception('Error fetching news from API: $e');
    }
  }

  Future<void> storeCarNews(List<dynamic> articles) async {
    for (var article in articles) {
      final carNews = CarNews(
        title: article['title'] ?? '',
        description: article['description'] ?? '',
        imageUrl: article['urlToImage'] ?? '',
        author: article['author'] ?? '',
        content: article['content'] ?? '',
        publishedAt: article['publishedAt']?.toString() ?? '',

        url: article['url'] ?? '',
      );

      final existingDocs = await _firestore
          .collection('car_news')
          .where('url', isEqualTo: carNews.url)
          .get();

      if (existingDocs.docs.isEmpty) {
        await _firestore.collection('car_news').add(carNews.toMap());
      }
    }
  }

  Future<List<CarNews>> fetchCarNewsFromDB() async {
    try {
      final snapshot = await _firestore.collection('car_news').get();
      return snapshot.docs.map((doc) {
        return CarNews.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching news from Firestore: $e');
    }
  }

  Future<List<CarNews>> fetchAndStoreCarNews() async {
    try {
      // Step 1: Fetch news from API
      final articles = await fetchCarNewsFromAPI();
      await storeCarNews(articles);
      return await fetchCarNewsFromDB();
    } catch (e) {
      throw Exception('Error in fetch and store workflow: $e');
    }
  }
}
