import 'package:flutter/material.dart';

class ChooseDisabilityPage extends StatefulWidget {
  const ChooseDisabilityPage({Key? key}) : super(key: key);

  @override
  _ChooseDisabilityPageState createState() => _ChooseDisabilityPageState();
}

class _ChooseDisabilityPageState extends State<ChooseDisabilityPage> {
  final TextEditingController _uniqueAbilityController = TextEditingController();

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Spark Fitness",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _uniqueAbilityController,
              decoration: _inputDecoration('Not listed? Type your Unique ability here!'),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(), // Prevents GridView from scrolling
                crossAxisCount: 2,
                childAspectRatio: 1.3, // Adjusted aspect ratio for cards
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: <Widget>[
                  _buildCard("Physical Disability", Icons.accessible, context),
                  _buildCard("Visual Impairment", Icons.remove_red_eye, context),
                  _buildCard("Autism Spectrum", Icons.personal_injury_rounded, context),
                  _buildCard("Hearing Impairment", Icons.hearing, context),
                  _buildCard("Intellectual Disability", Icons.people, context),
                  _buildCard("Sensory Processing Disorder", Icons.pan_tool, context),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Full width button
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  String? selectedAbility = _uniqueAbilityController.text.isNotEmpty
                      ? _uniqueAbilityController.text
                      : null;
                  Navigator.pop(context, selectedAbility);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String text, IconData icon, BuildContext context) {
    return Card(
      color: Colors.grey[300],
      child: InkWell(
        onTap: () {
          Navigator.pop(context, text); // Return selected disability
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 40,
                color: Colors.black,
              ),
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
