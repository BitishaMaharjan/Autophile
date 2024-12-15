import 'package:flutter/material.dart';
import 'package:autophile/widgets/search_screen/car_card.dart';
import 'package:autophile/widgets/search_screen/filter_bar.dart';
import 'package:autophile/widgets/loading_skeleton.dart';
import 'package:autophile/models/car_modal.dart'; // Import the service

class SearchResultsWidget extends StatefulWidget {
  final String initialSearchQuery;


  SearchResultsWidget({Key? key, required this.initialSearchQuery}) : super(key: key);

  @override
  _SearchResultsWidgetState createState() => _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends State<SearchResultsWidget> {
  late String searchQuery;
  final TextEditingController _searchController = TextEditingController();
  List<CarData> filteredCars = [];
  bool isLoading = true;
  String selectedBrand = '';

  final CarDataService _carDataService = CarDataService();
  List<CarData> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchQuery = widget.initialSearchQuery;
    _searchController.text = searchQuery;
    _fetchAndFilterResults();
  }

  Future<void> _fetchAndFilterResults() async {
    setState(() => isLoading = true);
    try {
      final cars = await _carDataService.fetchCarData();
      setState(() {
        searchResults = cars;
        _updateResults();
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  void _updateResults() {
    setState(() {
      filteredCars = searchResults
          .where((car) {
        // Match query against make, model, or trim
        bool matchesQuery = car.make.toLowerCase().contains(searchQuery.toLowerCase()) ||
            car.model.toLowerCase().contains(searchQuery.toLowerCase()) ||
            car.trim.toLowerCase().contains(searchQuery.toLowerCase());

        // If a brand is selected, also filter by make
        bool matchesBrand = selectedBrand.isEmpty || car.make.toLowerCase() == selectedBrand.toLowerCase();

        return matchesQuery && matchesBrand;
      })
          .toList();
      isLoading = false;
    });
  }

  // Function for handling search button click
  void onSearchButtonPressed() {
    setState(() {
      searchQuery = _searchController.text.trim();
      _updateResults();
    });
  }


  void onFilterChanged(String brand) {
    setState(() {
      selectedBrand = brand;
      _updateResults();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterBarWidget(
          onFilterChanged: onFilterChanged,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Update search query dynamically on each keystroke
                    setState(() {
                      searchQuery = value.trim();
                    });
                    _updateResults(); // Update the results as the user types
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: onSearchButtonPressed, // Trigger the search when button is pressed
              ),
            ],
          ),
        ),
        // Show loading skeleton if isLoading is true
        isLoading
            ? LoadingSkeleton(isPost: false, isCarSearch: true)
            : (filteredCars.isEmpty
            ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No results found for "$searchQuery"',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          shrinkWrap: true,
          itemCount: filteredCars.length,
          itemBuilder: (context, index) {
            final car = filteredCars[index];
            return CarCardWidget(
              car: {
                'name': '${car.make} ${car.model}',
                'image': car.imageUrl,
                'mileage': car.engineSize,
                'seats': car.cylinders,
                'price': car.baseMsrp,
                'year': car.year,
                'cylinders': car.cylinders,
                'engineSize': car.engineSize,
                'fuelTankCapacity': car.fuelTankCapacity,
                'horsepower': car.horsepower,
                'make': car.make,
                'trim': car.trim,
                'trimDescription': car.trimDescription,
                'description': car.description,
                'assets': car.assets,
              },
            );
          },
        )),
      ],
    );
  }

}
