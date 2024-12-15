import 'package:cloud_firestore/cloud_firestore.dart';
class CarData {
  final String baseMsrp;
  final String cylinders;
  final String engineSize;
  final String fuelTankCapacity;
  final String horsepower;
  final String imageUrl;
  final String make;
  final String model;
  final String trim;
  final String trimDescription;
  final String year;
  final String description;
  final String assets;

  CarData({
    required this.baseMsrp,
    required this.cylinders,
    required this.engineSize,
    required this.fuelTankCapacity,
    required this.horsepower,
    this.imageUrl = 'assets/images/default-fallback-image.png',
    required this.make,
    required this.model,
    required this.trim,
    required this.trimDescription,
    required this.year,
    required this.description,
    this.assets = 'assets/models/nothing.glb', // Default value for assets
  });


  factory CarData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CarData(
      baseMsrp: data['Base MSRP'] ?? '',
      cylinders: data['Cylinders'] ?? '',
      engineSize: data['Engine size'] ?? '',
      fuelTankCapacity: data['Fuel tank capacity'] ?? '',
      horsepower: data['Horsepower'] ?? '',
      imageUrl: data['Image URL'] ?? 'assets/images/default-fallback-image.png',
      make: data['Make'] ?? '',
      model: data['Model'] ?? '',
      trim: data['Trim'] ?? '',
      trimDescription: data['Trim - description'] ?? '',
      year: data['Year'] ?? '',
      description: data['Description'] ?? '',
      // Use 'Assets' if available; otherwise, fallback to default
      assets: data.containsKey('Assets') && data['Assets'] != null
          ? data['Assets']
          : 'assets/models/nothing.glb',
    );
  }
}

class CarDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch car data from Firestore
  Future<List<CarData>> fetchCarData() async {
    try {
      final querySnapshot = await _firestore.collection('car_data').get();
      return querySnapshot.docs
          .map((doc) => CarData.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching car data: $e');
      return [];
    }
  }
  Future<void> addCarData(CarData carData) async {
    try {
      await _firestore.collection('car_data').add({
        'Base MSRP': carData.baseMsrp,
        'Cylinders': carData.cylinders,
        'Engine size': carData.engineSize,
        'Fuel tank capacity': carData.fuelTankCapacity,
        'Horsepower': carData.horsepower,
        'Image URL': carData.imageUrl,
        'Make': carData.make,
        'Model': carData.model,
        'Trim': carData.trim,
        'Trim - description': carData.trimDescription,
        'Year': carData.year,
        'Description': carData.description,
        'Assets': carData.assets, // Adding an empty assets field
      });
    } catch (e) {
      print('Error adding car data: $e');
    }
  }
}