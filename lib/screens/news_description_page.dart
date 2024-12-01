import 'package:flutter/material.dart';

class NewsDescriptionPage extends StatelessWidget {
  final String name;
  final String description;
  final String image;

  const NewsDescriptionPage({
    required this.name,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(image, height: 200, width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
