import 'package:flutter/material.dart';

class FilterBarWidget extends StatefulWidget {
  final ValueChanged<String> onFilterChanged;

  FilterBarWidget({required this.onFilterChanged});

  @override
  _FilterBarWidgetState createState() => _FilterBarWidgetState();
}

class _FilterBarWidgetState extends State<FilterBarWidget> {
  String? selectedBrand;
  List<String> brands = [
    'THAR',
    'Lini Gux',
    'SUV Classic',
    'Mustang',
    'BMW X5',
    'Tesla Model S',
    'Audi Q7',
    'Range Rover',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Filter on the left corner
        IconButton(
          icon: Icon(Icons.filter_alt),
          onPressed: () {
            _showFilterModal(context);
          },
        ),
        // Horizontal scrollable brand selection
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: brands.map((brand) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedBrand = brand;
                    });
                    widget.onFilterChanged(brand);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          brand,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4), // Space between text and underline
                        if (selectedBrand == brand)
                          Container(
                            height: 2.0, // Thickness of underline
                            width: (brand.length * 7.0) - 10.0, // Adjust width with a gap
                            color: Colors.blue,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Filter icon that triggers modal
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            _showFilterModal(context);
          },
        ),
      ],
    );
  }

  // Modal for price and other filters
  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price Filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Slider(
                value: 5000,
                min: 0,
                max: 100000,
                divisions: 20,
                label: 'Price',
                onChanged: (value) {},
              ),
              SizedBox(height: 16),
              Text('Other Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }
}
