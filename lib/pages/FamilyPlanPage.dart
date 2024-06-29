import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FamilyPlanPage extends StatelessWidget {
  const FamilyPlanPage({super.key});

  Future<void> _showPaymentDialog(BuildContext context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _cardNameController = TextEditingController();
    final TextEditingController _cardNumberController = TextEditingController();
    String _selectedMonth = '06';
    String _selectedYear = '24';
    final TextEditingController _cvvController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.credit_card),
              SizedBox(width: 8),
              Text('Enter Card Details'),
            ],
          ),
          backgroundColor: Colors.white,
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _cardNameController,
                  decoration: const InputDecoration(labelText: 'Card Holder Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the card holder name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the card number';
                    } else if (value.length != 16) {
                      return 'Card number must be 16 digits';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Expiry Month'),
                        value: _selectedMonth,
                        items: List.generate(12, (index) {
                          final month = (index + 1).toString().padLeft(2, '0');
                          return DropdownMenuItem(
                            value: month,
                            child: Text(month)                          );
                        }),
                        onChanged: (value) {
                          _selectedMonth = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Expiry Year'),
                        value: _selectedYear,
                        items: List.generate(10, (index) {
                          final year = (index + 23).toString();
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          );
                        }),
                        onChanged: (value) {
                          _selectedYear = value!;
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _cvvController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the CVV';
                    } else if (value.length != 3) {
                      return 'CVV must be 3 digits';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 94, 204, 255),),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveSubscription(context, _cardNameController.text, _cardNumberController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Pay', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveSubscription(BuildContext context, String cardHolderName, String cardNumber) async {
    final user = FirebaseAuth.instance.currentUser;
    final DatabaseReference databaseRef = FirebaseDatabase.instance.reference().child('Subscriptions');

    if (user != null) {
      final newSubscription = {
        'email': user.email,
        'date': DateTime.now().toIso8601String(),
        'subscription_type': 'Family Plan',
        'subscription_cost': '\$29.99',
        'subscription_duration': '1 Month',
        'subscription_exp_date': DateTime.now().add(Duration(days: 30)).toIso8601String(),
        'card_holder_name': '${cardHolderName[0]}*****${cardHolderName.substring(cardHolderName.length - 5)}',
        'card_number': '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}',
      };

      await databaseRef.push().set(newSubscription);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription successful!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: Scaffold(
        backgroundColor: Colors.white, // Set background color to white
        appBar: AppBar(
          title: const Text(
            'Family Plan',
            style: TextStyle(color: Colors.black), // Set text color to black
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black, // Set icon color to black
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10), // Adjust margin for the bell icon
              child: IconButton(
                icon: const Icon(Icons.notifications),
                color: Colors.black, // Set icon color to black
                onPressed: () {
                  // Implement notification functionality
                },
              ),
            ),
          ],
          backgroundColor: Colors.white, // Set app bar background color to white
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plan Details',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200, // Increased image size
                      child: Image.network(
                        'https://kajabi-storefronts-production.kajabi-cdn.com/kajabi-storefronts-production/file-uploads/themes/2155085722/settings_images/7a07fe-006a-47e6-d885-651cec38541d_2.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Price: \$29.99/Month',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Features:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Unlimited access to all family fitness classes',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Special Offer: First month free!',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subscription Form',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _showPaymentDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 94, 204, 255), // Change button color
                        minimumSize: const Size(double.infinity, 50), // Full width button
                      ),
                      child: const Text(
                        'Subscribe Now',
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Subscribe now to enjoy family fitness sessions with your loved ones!',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
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
                color: const Color.fromARGB(255, 94, 204, 255),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                color: Colors.black,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                color: Colors.black,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                color: Colors.black,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

