class Car {
  final int id;
  final String make;
  final String model;
  final int year;
  final String trim;
  final String description;
  final String baseMsrp;
  final String baseInvoice;
  final String imageUrl;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.trim,
    required this.description,
    required this.baseMsrp,
    required this.baseInvoice,
    required this.imageUrl,
  });

  // Factory constructor to convert from a Map (Firebase data)
  factory Car.fromMap(Map<String, dynamic> data) {
    return Car(
      id: data['ID'],
      make: data['Make'],
      model: data['Model'],
      year: data['Year'],
      trim: data['Trim'],
      description: data['Description'],
      baseMsrp: data['Base MSRP'],
      baseInvoice: data['Base Invoice'],
      imageUrl: data['Image URL'],
    );
  }
}
