import 'package:flutter/material.dart';
import 'package:autophile/widgets/search_screen/featured_car_list.dart';
import 'package:autophile/widgets/search_screen/trending_news_list.dart';
import 'package:autophile/widgets/search_screen/search_bar.dart';
import 'package:autophile/widgets/search_screen/mic_modal.dart';
import 'package:autophile/widgets/search_screen/car_brand_section.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:autophile/screens/dashboard/search_result.dart';
import 'package:autophile/services/news_service.dart';
import 'package:autophile/widgets/loading_skeleton.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final NewsService _newsService = NewsService();
  bool isLoading = true; // To handle the loading state
  List<Map<String, dynamic>> trendingCars = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();


  @override
  void initState() {
    super.initState();
    _fetchCarModel();
    fetchTrendingNews();

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
            'url': article.url ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/BBC_News_2022_%28Alt%29.svg/1024px-BBC_News_2022_%28Alt%29.svg.png', // Ensure URL is not null
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

  // Fetch the data asynchronously

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
          carYear = data['Year']?.toString(); // Safe call with null check
        }

        setState(() {
          // Uncomment and use your state variables here
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


  bool isSearching = false; // Tracks if search results should be displayed
  String searchQuery = '';

  final List<Map<String, dynamic>> featuredCars = [
    {'id': 1, 'name': 'Dodge X24', 'price': '12.5', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSO1q5iuu6wJJpVVV5U4Gr_SvpPwdiiYzXGcg&s', 'seats': 7},
    {'id': 2, 'name': 'Porsche Cayenne', 'price': '15.0', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSO1q5iuu6wJJpVVV5U4Gr_SvpPwdiiYzXGcg&s', 'seats': 5},
  ];


  void _openMicModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MicSearchModal();
      },
    );
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
                  });
                },
                onMicPressed: _openMicModal,
              ),
              const SizedBox(height: 20),
              isSearching
                  ? SearchResultsWidget(initialSearchQuery: searchQuery)
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
                      ? const LoadingSkeleton(isPost:false,isCarSearch: false,) // Show loading spinner if still fetching
                      : TrendingNewsList(trendingCars: trendingCars), // Show trending cars once data is available
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
