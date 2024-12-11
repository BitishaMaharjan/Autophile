import 'package:flutter/material.dart';
import 'package:autophile/widgets/search_screen/car_card.dart';
import 'package:autophile/widgets/search_screen/filter_bar.dart';
import 'package:autophile/widgets/loading_skeleton.dart'; // Assuming you have this widget

class SearchResultsWidget extends StatefulWidget {
  final String initialSearchQuery;

  SearchResultsWidget({Key? key, required this.initialSearchQuery}) : super(key: key);

  @override
  _SearchResultsWidgetState createState() => _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends State<SearchResultsWidget> {
  late String searchQuery;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredCars = [];
  bool isLoading = true;

  final List<Map<String, String>> searchResults = [
    {
      "name": "THAR",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSO1q5iuu6wJJpVVV5U4Gr_SvpPwdiiYzXGcg&s",
      "mileage": "12.5",
      "seats": "5",
      "price": "\$12,000",
    },
    {
      "name": "Lini Gux",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSO1q5iuu6wJJpVVV5U4Gr_SvpPwdiiYzXGcg&s",
      "mileage": "12.5",
      "seats": "5",
      "price": "\$90,008",
    },
    {
      "name": "SUV Classic",
      "image": "assets/suv_classic.png",
      "mileage": "10",
      "seats": "7",
      "price": "\$40,000",
    },
  ];

  @override
  void initState() {
    super.initState();
    searchQuery = widget.initialSearchQuery;
    _searchController.text = searchQuery;
    _updateResults();
  }

  void _updateResults() {
    setState(() {
      filteredCars = searchResults
          .where((car) => car['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      isLoading = false;
    });
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      isLoading = true;
      _updateResults();
    });
  }

  void onFilterChanged(String filter) {
    // Handle filter changes if needed
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterBarWidget(
          onFilterChanged: (brand) {
            // Handle the brand filter change
            print('Selected brand: $brand');
          },
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
            return CarCardWidget(car: car);
          },
        )),
      ],
    );
  }
}
