import 'package:flutter/material.dart';

class FeaturedCarsList extends StatelessWidget {
  final List<Map<String, dynamic>> featuredCars;

  const FeaturedCarsList({required this.featuredCars});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: featuredCars.map((car) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(car['image'], height: 120, width: double.infinity, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(car['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("\u{1F4B5} ${car['price']} | \u{1F697} ${car['seats']} Seats", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
