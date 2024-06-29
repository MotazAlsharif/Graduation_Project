import 'package:flutter/material.dart';
import 'package:sfit/pages/FavoriteCoachesListPage.dart';
import 'package:sfit/pages/Homepage.dart';
import 'package:sfit/pages/FilterPage.dart';
import 'package:sfit/pages/ViewCoachProfilePage.dart';

class Coach {
  final String name;
  final String image;
  final double rating;
  final bool isLocal;
  final String sport;
  final int age;
  final String coachingHours;

  Coach({
    required this.name,
    required this.image,
    required this.rating,
    this.isLocal = false,
    required this.sport,
    required this.age,
    required this.coachingHours,
  });
}

List<Coach> favoriteCoaches = [];

class SearchCoachesPage extends StatefulWidget {
  const SearchCoachesPage({super.key});

  @override
  _SearchCoachesPageState createState() => _SearchCoachesPageState();
}

class _SearchCoachesPageState extends State<SearchCoachesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Coach> coaches = [
    Coach(name: "Raed Al-Sharif", image: "lib/images/Raed.png", rating: 4.7, isLocal: true, sport: "Body Fitness", age: 33, coachingHours: "8AM-2PM"),
    Coach(name: "Mohammad Oqaily", image: "lib/images/Oqaily.jpeg", rating: 4.5, isLocal: true, sport: "Basketball", age: 29, coachingHours: "10AM-4PM"),
    Coach(name: "Amro Reda", image: "lib/images/Amro.jpg", rating: 3.8, isLocal: true, sport: "Badminton", age: 30, coachingHours: "10AM-4PM"),
  ];
  List<Coach> filteredCoaches = [];

  @override
  void initState() {
    super.initState();
    filteredCoaches = coaches;
    _searchController.addListener(_filterCoaches);
    _logImagePaths(); // Log image paths for debugging
  }

  void _filterCoaches() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredCoaches = coaches.where((coach) {
        return coach.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _logImagePaths() {
    for (var coach in coaches) {
      print('Loading image for ${coach.name} from ${coach.image}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          title: const Text(
            "Search for coaches",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilterPage()),
                );
              },
              color: Colors.black,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Implement search action here
                      },
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              ...filteredCoaches.map((coach) => CoachCard(
                coachName: coach.name,
                coachImage: coach.image,
                coachRating: coach.rating,
                isLocalImage: coach.isLocal,
                sport: coach.sport,
                age: coach.age,
                coachingHours: coach.coachingHours,
              )),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    filteredCoaches.addAll([
                      Coach(name: "Sarah Johnson", image: "lib/images/Sarah.jpg", rating: 4.9, sport: "Basketball", age: 31, coachingHours: "4PM-9PM", isLocal: true),
                      Coach(name: "Alex Rodriguez", image: "lib/images/Alex.jpeg", rating: 4.6, sport: "Baseball", age: 35, coachingHours: "9AM-2PM", isLocal: true),
                    ]);
                  });
                },
                child: const Center(
                  child: Text(
                    'Load more...',
                    style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SportsCoachesPage(userDetails: {})),
                  );
                },
                color: Colors.black,
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Navigate to search
                },
                color: const Color.fromARGB(255, 94, 204, 255),
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoriteCoaches(title: 'Favorite Coaches')),
                  );
                },
                color: Colors.black,
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  // Navigate to profile
                },
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class CoachCard extends StatefulWidget {
  final String coachName;
  final String coachImage;
  final double coachRating;
  final bool isLocalImage;
  final String sport;
  final int age;
  final String coachingHours;

  const CoachCard({
    super.key, 
    required this.coachName, 
    required this.coachImage, 
    required this.coachRating, 
    this.isLocalImage = false,
    required this.sport,
    required this.age,
    required this.coachingHours,
  });

  @override
  _CoachCardState createState() => _CoachCardState();
}

class _CoachCardState extends State<CoachCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: SizedBox(
                  height: 150.0,
                  child: widget.isLocalImage
                      ? Image.asset(
                          widget.coachImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Image.network(
                          widget.coachImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          },
                        ),
                ),
              ),
              Positioned(
                top: 10.0,
                left: 10.0,
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.yellow),
                      const SizedBox(width: 5.0),
                      Text(
                        widget.coachRating.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10.0,
                right: 10.0,
                child: IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                      if (isFavorite) {
                        favoriteCoaches.add(Coach(
                          name: widget.coachName,
                          image: widget.coachImage,
                          rating: widget.coachRating,
                          isLocal: widget.isLocalImage,
                          sport: widget.sport,
                          age: widget.age,
                          coachingHours: widget.coachingHours,
                        ));
                      } else {
                        favoriteCoaches.removeWhere((coach) => coach.name == widget.coachName);
                      }
                    });
                  },
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.coachName,
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text('Sport: ${widget.sport}'),
                    Text('Age: ${widget.age}'),
                    Text('Hours: ${widget.coachingHours}'),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewCoachProfilePage(
                          coachName: widget.coachName,
                          coachImage: widget.coachImage,
                          coachRating: widget.coachRating,
                          coachSport: widget.sport,
                          isLocalImage: widget.isLocalImage,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 94, 204, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                  child: const Text(
                    "Details",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
