// import 'package:flutter/material.dart';
//
// class TrendingNewsList extends StatelessWidget {
//   final List<Map<String, dynamic>> trendingCars;
//   final VoidCallback onViewMore;
//
//   const TrendingNewsList({required this.trendingCars, required this.onViewMore});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: trendingCars.map((car) {
//         return Card(
//           margin: const EdgeInsets.only(bottom: 15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.network(car['image'], height: 150, width: double.infinity, fit: BoxFit.cover),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(car['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 5),
//                     Text(
//                       car['description'],
//                       style: TextStyle(fontSize: 14, color: Colors.grey),
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 5),
//                     GestureDetector(
//                       onTap: onViewMore,
//                       child: Text(
//                         'View More',
//                         style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:autophile/screens/news_description_page.dart';

class TrendingNewsList extends StatelessWidget {
  final List<Map<String, dynamic>> trendingCars;

  const TrendingNewsList({required this.trendingCars});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: trendingCars.map((car) {
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(car['image'], height: 150, width: double.infinity, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(
                      car['description'],
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
                              name: car['name'],
                              description: car['description'],
                              image: car['image'],
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

