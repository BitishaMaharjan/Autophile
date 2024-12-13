import 'package:flutter/material.dart';
import 'package:autophile/screens/news_description_page.dart';

class TrendingNewsList extends StatelessWidget {
  final List<Map<String, dynamic>> trendingCars;

  const TrendingNewsList({required this.trendingCars});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: trendingCars.map((news_car) {
        return Card(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          margin: const EdgeInsets.only(bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                news_car['image'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news_car['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      news_car['description'],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDescriptionPage(
                              title: news_car['name'],
                              description: news_car['description'],
                              imageUrl: news_car['image'] ,
                              author: news_car['author'],
                              content: news_car['content'],
                              publishedAt: news_car['publishedAt'] ,// Map the publis
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'View More',
                        style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
