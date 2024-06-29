import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MySubscriptionsPage extends StatefulWidget {
  MySubscriptionsPage({super.key});

  @override
  _MySubscriptionsPageState createState() => _MySubscriptionsPageState();
}

class _MySubscriptionsPageState extends State<MySubscriptionsPage> {
  final DatabaseReference _subscriptionsRef = FirebaseDatabase.instance.reference().child('Subscriptions');
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Subscriptions'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Serial Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _subscriptionsRef.orderByChild('email').equalTo(user?.email).onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  Map data = snapshot.data!.snapshot.value as Map;
                  List subscriptions = data.values.toList();

                  // Filter subscriptions based on search query
                  List filteredSubscriptions = subscriptions.where((subscription) {
                    if (_searchQuery.isEmpty) {
                      return true;
                    } else {
                      return subscription['serial_code'] != null &&
                          subscription['serial_code']
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());
                    }
                  }).toList();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: filteredSubscriptions.map<Widget>((subscription) {
                        return SubscriptionCard(
                          subscriptionType: subscription['subscription_type'] ?? 'Group Plan',
                          planName: subscription['plan_name'] ?? 'Premium Fitness',
                          description: subscription['description'] ?? 'Access to premium fitness features',
                          price: subscription['subscription_cost'] ?? 'N/A',
                          features: List<String>.from(subscription['features'] ?? ['Personal Trainer']),
                          numberOfFriends: subscription['number_of_friends'] ?? 'N/A',
                          serialCode: subscription['serial_code'] ?? 'N/A',
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return const Center(child: Text('You have not Subscribed to our Fitness Plans!'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String subscriptionType;
  final String planName;
  final String description;
  final String price;
  final List<String> features;
  final String numberOfFriends;
  final String serialCode;

  const SubscriptionCard({
    super.key,
    required this.subscriptionType,
    required this.planName,
    required this.description,
    required this.price,
    required this.features,
    required this.numberOfFriends,
    required this.serialCode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subscriptionType,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              planName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              description,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Price: $price',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Features:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...features.map((feature) => Text('- $feature', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10.0),
            Text(
              'Number of Friends: $numberOfFriends',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Serial Code: $serialCode',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}