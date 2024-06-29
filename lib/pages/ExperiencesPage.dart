import 'package:flutter/material.dart';

class ExperiencesPage extends StatelessWidget {
  const ExperiencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color of the scaffold to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Set background color of the app bar to white
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Set back arrow color to black
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Coach Experiences',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Set text color to black and bold
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ExperienceCard(
              title: 'Experience 1',
              description: 'Description for Experience 1 goes here.',
            ),
            SizedBox(height: 20),
            ExperienceCard(
              title: 'Experience 2',
              description: 'Description for Experience 2 goes here.',
            ),
            SizedBox(height: 20),
            ExperienceCard(
              title: 'Experience 3',
              description: 'Description for Experience 3 goes here.',
            ),
          ],
        ),
      ),
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final String title;
  final String description;

  const ExperienceCard({super.key, 
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}