import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

class ThreedModelPage extends StatefulWidget {
  const ThreedModelPage({super.key});

  @override
  State<ThreedModelPage> createState() => _ThreedModelPageState();
}

class _ThreedModelPageState extends State<ThreedModelPage> {
  O3DController o3dController = O3DController();
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> details = [
      {'icon': '⛽', 'title': 'Range', 'value': '12.5km'},
      {'icon': '🚀', 'title': 'Speed', 'value': '350/kph'},
      {'icon': '🪑', 'title': 'Capacity', 'value': '2 seat'},
      {'icon': '⚙️', 'title': 'Gear', 'value': 'Manual'},
      {'icon': '🔋', 'title': 'Engine', 'value': '2300Hp'},
      {'icon': '🛞', 'title': 'Drive', 'value': 'FWD (R4)'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('3D Model'),centerTitle: true,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tesla Model 3',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 400,  // You can adjust this value
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/threeDModel.png',
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                  ),

                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: O3D(
                      src: 'assets/models/tesla_2018_model_3.glb',
                      controller: o3dController,
                      ar: false,
                      autoPlay: true,
                      autoRotate: false,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'The Tesla Model S is a battery-electric, four-door full-size car that has been produced by the American automaker Tesla since 2012. .',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: details.map((detail) {
                return Container(
                  width: 100,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        detail['icon'] ?? '',
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        detail['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        detail['value'] ?? '',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )

          ],
        ),
      ),
    );
  }
}
