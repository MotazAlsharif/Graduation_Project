import 'package:flutter/material.dart';
import 'package:sfit/pages/Homepage.dart';

class SportsInterestsPage extends StatelessWidget {
  final Map<String, dynamic> userDetails;

  const SportsInterestsPage({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light, // Default theme is light
      ),
      home: SportsInterestsBody(userDetails: userDetails),
    );
  }
}

class SportsInterestsBody extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const SportsInterestsBody({super.key, required this.userDetails});

  @override
  _SportsInterestsBodyState createState() => _SportsInterestsBodyState();
}

class _SportsInterestsBodyState extends State<SportsInterestsBody> {
  Map<String, bool> favorites = {
    "Table Tennis": false,
    "Football": false,
    "Taekwondo": false,
    "Basketball": false,
    "Tennis": false,
    "Badminton": false,
  };

  bool isNightMode = false; // Track the current mode
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isNightMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isNightMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SportsCoachesPage(userDetails: widget.userDetails)),
            );
          },
        ),
        title: Text(
          "What sport interests you?",
          style: TextStyle(
            color: isNightMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: BottomAppBar(
        color: isNightMode ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SportsCoachesPage(userDetails: widget.userDetails),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isNightMode ? Colors.white : const Color.fromARGB(255, 96, 184, 255),
                ),
                child: const Text(
                  "Finish",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: isNightMode ? Colors.black : Colors.white, // Set background color based on mode
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Search sport",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: isNightMode ? Colors.grey[900] : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: favorites.keys
                  .where((sportName) => sportName.toLowerCase().contains(_searchController.text.toLowerCase()))
                  .map((sportName) {
                return _buildSportCard(
                  sportName,
                  "https://st3.depositphotos.com/1006542/15792/i/450/depositphotos_157923524-stock-photo-table-tennis-rackets.jpg",
                  context,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                // Add your load more functionality here
              },
              child: Text(
                "Load more",
                style: TextStyle(
                  color: isNightMode ? Colors.white : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSportCard(String sportName, String imageUrl, BuildContext context) {
    Map<String, String> sportImages = {
      "Table Tennis": "https://st3.depositphotos.com/1006542/15792/i/450/depositphotos_157923524-stock-photo-table-tennis-rackets.jpg",
      "Football": "https://media.istockphoto.com/id/919576788/photo/soccer-or-football-player-standing-with-ball-on-the-field-for-kick-the-soccer-ball-at-football.jpg?s=612x612&w=0&k=20&c=Ws3fPUZdZy0JgBe0vbdYXfV_6Hw4-21os9PrgxiPByk=",
      "Taekwondo": "https://cdn.hswstatic.com/gif/taekwondo.jpg",
      "Basketball": "https://media.istockphoto.com/id/531521039/photo/slam-dunk.jpg?s=612x612&w=0&k=20&c=jP_WWqMcAKQX3v1HVNn5mB59yS5DWXKdvfjTsO7_Owo=",
      "Tennis": "https://reviewed-com-res.cloudinary.com/image/fetch/s--UJ2sGByA--/b_white,c_limit,cs_srgb,f_auto,fl_progressive.strip_profile,g_center,q_auto,w_972/https://reviewed-production.s3.amazonaws.com/1597356287543/GettyImages-1171084311.jpg",
      "Badminton": "https://img.olympics.com/images/image/private/t_twitter_share_thumb/f_auto/primary/ybf4bxkp9jbccxxxg3kx",
    };

    String sportImageUrl = sportImages[sportName] ?? '';

    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).cardColor, // Set card color based on theme
      child: Stack(
        children: [
          Image.network(
            sportImageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: Icon(
                favorites[sportName] ?? false ? Icons.favorite : Icons.favorite_border,
                color: favorites[sportName] ?? false ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  favorites[sportName] = !(favorites[sportName] ?? false);
                });
              },
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Text(
              sportName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16, // Adjust the font size here
              ),
            ),
          ),
        ],
      ),
    );
  }
}
