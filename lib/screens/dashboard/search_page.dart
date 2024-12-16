import 'package:flutter/material.dart';
import 'package:autophile/widgets/search_screen/featured_car_list.dart';
import 'package:autophile/widgets/search_screen/trending_news_list.dart';
import 'package:autophile/widgets/search_screen/search_bar.dart';
import 'package:autophile/widgets/search_screen/mic_modal.dart';
import 'package:autophile/widgets/search_screen/filter_bar.dart';
import 'package:autophile/widgets/search_screen/car_card.dart';
import 'package:autophile/widgets/loading_skeleton.dart';
import 'package:autophile/models/car_modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:autophile/services/news_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final NewsService _newsService = NewsService();
  final CarDataService _carDataService = CarDataService();

  bool isLoading = true;
  bool isSearching = false;
  String searchQuery = '';

  List<Map<String, dynamic>> trendingCars = [];
  List<CarData> searchResults = [];
  List<CarData> filteredCars = [];

  String selectedBrand = '';
  final TextEditingController _searchController = TextEditingController();

  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _fetchCarModel();
    fetchTrendingNews();
    _fetchCarData();
  }

  Future<void> _fetchCarData() async {
    try {
      final cars = await _carDataService.fetchCarData();
      setState(() {
        searchResults = cars;
      });
    } catch (e) {
      print('Error fetching car data: $e');
    }
  }

  Future<void> fetchTrendingNews() async {
    try {
      final articles = await _newsService.fetchAndStoreCarNews();

      setState(() {
        trendingCars = articles.map((article) {
          return {
            'name': article.title ?? 'No Title Available',
            'image': article.imageUrl ?? 'https://via.placeholder.com/150',
            'description': article.description ?? 'No Description Available',
            'content': article.content ?? 'No content available',
            'author': article.author ?? 'Unknown Author',
            'url': article.url ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/BBC_News_2022_%28Alt%29.svg/1024px-BBC_News_2022_%28Alt%29.svg.png',
            'publishedAt': article.publishedAt ?? 'Unknown Date',
          };
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching car news: $e");
    }
  }

  Future<void> _fetchCarModel() async {
    try {
      DatabaseEvent event = await ref.once();
      Query query = ref.orderByChild("Model").limitToFirst(10);

      DataSnapshot event2 = await query.get();
      print(event2);

      if (event.snapshot.value != null) {
        var data = event.snapshot.value;

        String? carMake, carModel, carYear;

        if (data is List) {
          var firstCar = data.firstWhere(
                (car) => car is Map<String, dynamic>,
            orElse: () => null,
          );

          if (firstCar != null) {
            carMake = firstCar['Make'];
            carModel = firstCar['Model'];
            carYear = firstCar['Year']?.toString();
          }
        } else if (data is Map<String, dynamic>) {
          carMake = data['Make'];
          carModel = data['Model'];
          carYear = data['Year']?.toString();
        }

        setState(() {
          // Uncomment and use your state variables here if needed
          // carMakeState = carMake;
          // carModelState = carModel;
          // carYearState = carYear;
        });
      } else {
        print("No data found in the database.");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _updateResults() {
    setState(() {
      filteredCars = searchResults
          .where((car) {
        bool matchesQuery = car.make.toLowerCase().contains(searchQuery.toLowerCase()) ||
            car.model.toLowerCase().contains(searchQuery.toLowerCase()) ||
            car.trim.toLowerCase().contains(searchQuery.toLowerCase());

        bool matchesBrand = selectedBrand.isEmpty || car.make.toLowerCase() == selectedBrand.toLowerCase();

        return matchesQuery && matchesBrand;
      })
          .toList();
    });
  }

  void _openMicModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MicSearchModal();
      },
    );
  }

  void onFilterChanged(String brand) {
    setState(() {
      selectedBrand = brand;
      _updateResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWidget(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    isSearching = value.isNotEmpty;
                    _updateResults();
                  });
                },
                onMicPressed: _openMicModal,
              ),
              const SizedBox(height: 20),
              isSearching
                  ? Column(
                children: [
                  FilterBarWidget(
                    onFilterChanged: onFilterChanged,
                  ),
                  // Show loading skeleton if results are empty
                  filteredCars.isEmpty
                      ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No results found for "$searchQuery"',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Featured Posts",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  FeaturedPostsList(),
                  const SizedBox(height: 20),
                  const Text(
                    "Trending News",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? const LoadingSkeleton(isPost: false, isCarSearch: false)
                      : TrendingNewsList(trendingCars: trendingCars),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}