import 'package:flutter/material.dart';
import 'package:autophile/screens/threeD_model_page.dart';
class CarDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> car;

  const CarDetailsScreen({Key? key, required this.car}) : super(key: key);

  @override
  _CarDetailsScreenState createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.43,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/main_side_black_shape.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: MediaQuery.of(context).size.width * 0.02,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Text(
                            widget.car['year'] ?? 'Unknown Date',
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '📅Release',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 110),
                           Text(
                             widget.car['price'] ?? 'Unknown Date',

                             style: const TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '💲Price ',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 50),
                          // ElevatedButton with Box Shadow
                          Material(
                            elevation: 8,
                            shadowColor: Colors.white.withOpacity(1),
                            shape: const CircleBorder(),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>  ThreedModelPage(car: widget.car,),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                              ),
                              child: Text(
                                '3D\nModel',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onTertiary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                           Text(
          widget.car['mileage'] ?? 'Na data',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'mileage',
                            style: TextStyle(
                              fontSize: 15,
                              color: colorScheme.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: CarDescriptionBox(car: widget.car),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: colorScheme.surface,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                             widget.car['name'] ?? '' ,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Image.asset(
                       widget.car['image'] ??  'assets/images/ferrari.png',
                          fit: BoxFit.contain,
                          width: constraints.maxWidth * 0.5,
                          height: constraints.maxHeight * 0.6,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CarDescriptionBox extends StatefulWidget {
  final Map<String, dynamic> car;

  const CarDescriptionBox({Key? key, required this.car}) : super(key: key);

  @override
  _CarDescriptionBoxState createState() => _CarDescriptionBoxState();
}

class _CarDescriptionBoxState extends State<CarDescriptionBox> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String description = widget.car['description'] ?? 'No description available';

    final screenWidth = MediaQuery.of(context).size.width;
    const double avgWordWidth = 7.5; // Approximate average word width in pixels
    const double paddingWidth = 32; // Account for container padding (16 + 16)
    final maxCharsPerLine = ((screenWidth - paddingWidth) / avgWordWidth).floor();
    const int lines = 2; // Number of lines before truncation
    final int maxWords = maxCharsPerLine * lines ~/ avgWordWidth; // Estimate max words

    // Split description into words
    final words = description.split(' ');
    final bool needsTruncation = words.length > maxWords;

    // Decide what to display
    final displayText = needsTruncation && !_isExpanded
        ? words.take(maxWords).join(' ') + '...'
        : description;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          if (needsTruncation)
            TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'See Less' : 'See More',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

