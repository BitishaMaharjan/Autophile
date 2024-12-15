import 'package:flutter/material.dart';
import 'package:autophile/screens/car_info_page.dart';

class CarCardWidget extends StatelessWidget {
  final Map<String, dynamic> car;

  CarCardWidget({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print(car);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailsScreen(car: car),
            ),
          );
        },
    child:  Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                car['image']!,
                height: 120,
                width: 170,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price: ${car['price']} ',

                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'HorsePower: ${car['horsepower']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Mileage: ${car['mileage']} km/l',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}
