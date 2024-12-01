import 'package:flutter/material.dart';

class CarBrandSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> carBrands;
  final VoidCallback? onViewAllPressed;

  const CarBrandSection({
    required this.title,
    required this.carBrands,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (onViewAllPressed != null)
              TextButton(
                onPressed: onViewAllPressed,
                child: const Text("View All", style: TextStyle(color: Colors.blue)),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: carBrands.map((brand) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(brand['logo']),
                    ),
                    const SizedBox(height: 5),
                    Text(brand['name'], style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
