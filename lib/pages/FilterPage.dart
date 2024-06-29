import 'package:flutter/material.dart';
import 'package:sfit/pages/SearchCoachPage.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedOption = ''; // Keep track of the selected option
  double priceRange = 50; // Initial price range

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set entire page background color to white
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56), // Default height of AppBar
        child: AppBar(
          backgroundColor: Colors.white, // Set AppBar background color to white
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back when back arrow is pressed
            },
          ),
          title: const Text(
            "Search",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Filter by:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20), // Add spacing between Filter by text and options
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterOption("Experience"),
                        const SizedBox(width: 10),
                        _buildFilterOption("Available now"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildFilterOption("Active"),
                const SizedBox(width: 10),
                _buildFilterOption("Highly Rated"),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Price range",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "\$10",
                  style: TextStyle(color: Colors.black), // Set price range text color to blue
                ), // Start of price range
                Expanded(
                  child: Slider(
                    value: priceRange,
                    min: 10,
                    max: 100,
                    divisions: 9,
                    onChanged: (value) {
                      setState(() {
                        priceRange = value;
                      });
                    },
                    label: '${priceRange.toStringAsFixed(0)}\$', // Display price value
                    activeColor: const Color.fromARGB(255, 94, 204, 255), // Set price range line color to blue
                  ),
                ),
                const Text(
                  "\$100",
                  style: TextStyle(color: Colors.black), // Set price range text color to blue
                ), // End of price range
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add logic to apply filters
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchCoachesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 94, 204, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 16.0),
                ),
                child: const Text(
                  "Apply Filters",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String option) {
    bool isSelected = selectedOption == option; // Check if option is selected
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option; // Set selected option
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 94, 204, 255) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          option,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
