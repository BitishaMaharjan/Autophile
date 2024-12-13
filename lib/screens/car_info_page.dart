import 'package:flutter/material.dart';

class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key});

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
                width: constraints.maxWidth * 0.4,
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
                      left: MediaQuery.of(context).size.width * 0.03,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          const Text(
                            '24',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Jan\nrelease\n2024',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 110),
                           const Text(
                            '45K \$',
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'release',
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('3D Model Button Pressed')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                              ),
                              child: Text(
                                '3D\nModel',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onTertiary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                          const Text(
                            '90 mpg',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'mileage',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
                              'Ferrari 290',
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
                          'assets/images/ferrari.png',
                          fit: BoxFit.contain,
                          width: constraints.maxWidth * 0.5,
                          height: constraints.maxHeight * 0.6,
                        ),
                      ),
                      const Positioned(
                        bottom: 20,
                        left: 0,
                        right: 20,
                        child: CarDescriptionBox(),
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
  const CarDescriptionBox({super.key});

  @override
  _CarDescriptionBoxState createState() => _CarDescriptionBoxState();
}

class _CarDescriptionBoxState extends State<CarDescriptionBox> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'The Tesla Model S is a battery-electric, four-door full-size car that has been produced by the American automaker Tesla since 2012. The Tesla Model S is a battery-electric, four-door full-size car.',
        style: TextStyle(
        color: Colors.white,
          fontSize: 14,
          height: 1.5,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
