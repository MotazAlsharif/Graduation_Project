import 'package:flutter/material.dart';
import 'package:sfit/pages/SearchCoachPage.dart';
import 'package:sfit/pages/Homepage.dart';
import 'package:sfit/pages/TraineeProfilePage.dart';

class FavoriteCoaches extends StatefulWidget {
  const FavoriteCoaches({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _FavoriteCoachesState createState() => _FavoriteCoachesState();
}

class _FavoriteCoachesState extends State<FavoriteCoaches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Set the app bar background color to white
        centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.notifications, color: Colors.black),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favoriteCoaches.length,
              itemBuilder: (context, index) {
                final coach = favoriteCoaches[index];
                return InkWell(
                  onTap: () {
                    _showCoachDetails(
                      context,
                      coach.name,
                      coach.sport,
                      coach.image,
                      coach.isLocal,
                      coach.age,
                      coach.coachingHours,
                    );
                  },
                  child: _buildCoachCard(
                    coach.image,
                    coach.name,
                    coach.sport,
                    coach.isLocal,
                    coach.age,
                    coach.coachingHours,
                    () {
                      setState(() {
                        favoriteCoaches.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Set the bottom navigation bar background color to white
        elevation: 0, // Remove the shadow effect
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false, // Hide the labels
        showUnselectedLabels: false, // Hide the labels
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SportsCoachesPage(userDetails: {})),
                );
              },
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchCoachesPage()),
                );
              },
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: IconButton(
              icon: const Icon(Icons.favorite, color: Color.fromARGB(255, 94, 204, 255)),
              onPressed: () {
                // Do nothing as we are already on the Favorites page
              },
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TraineeProfilePage()),
                );
              },
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCoachCard(String imageUrl, String name, String sport, bool isLocal, int age, String coachingHours, VoidCallback onDelete) {
    return Container(
      width: 410, // Set width
      height: 150, // Adjust height to accommodate new fields
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add padding
      child: Card(
        color: Colors.grey[200], // Set the card background color to grey
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20), // Adjust border radius as needed
            child: isLocal
                ? Image.asset(
                    imageUrl,
                    width: 70, // Set image width
                    height: 70, // Set image height
                    fit: BoxFit.cover, // Adjust how the image fits into the space
                  )
                : Image.network(
                    imageUrl,
                    width: 70, // Set image width
                    height: 70, // Set image height
                    fit: BoxFit.cover, // Adjust how the image fits into the space
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Image.network(
                        'https://via.placeholder.com/70', // Placeholder image URL
                        width: 70, // Set image width
                        height: 70, // Set image height
                        fit: BoxFit.cover, // Adjust how the image fits into the space
                      );
                    },
                  ),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold), // Make the name bold
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sport: $sport'),
              Text('Age: $age'),
              Text('Hours: $coachingHours'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }

  void _showCoachDetails(BuildContext context, String name, String sport, String imageUrl, bool isLocal, int age, String coachingHours) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Coach Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      backgroundImage: isLocal
                          ? AssetImage(imageUrl)
                          : NetworkImage(imageUrl) as ImageProvider,
                      radius: 50,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Coach Name: $name',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sport Coaching: $sport',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _getSportIcon(sport),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Age: $age'),
                    const SizedBox(height: 10),
                    Text('Hours: $coachingHours'),
                  ],
                ),
              ),
              Positioned(
                right: 5, // Adjusted position of the close button
                top: 5, // Adjusted position of the close button
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 15,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'basketball':
        return const Icon(Icons.sports_basketball);
      case 'baseball':
        return const Icon(Icons.sports_baseball);
      case 'body fitness':
        return const Icon(Icons.fitness_center);
      case 'badminton':
        return const Icon(Icons.sports_tennis);
      default:
        return const Icon(Icons.sports);
    }
  }
}
