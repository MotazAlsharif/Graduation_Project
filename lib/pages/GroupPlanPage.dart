import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:sfit/pages/MySubscriptions.dart'; // Add this import

class GroupPlanPage extends StatefulWidget {
  const GroupPlanPage({super.key});

  @override
  _GroupPlanPageState createState() => _GroupPlanPageState();
}

class _GroupPlanPageState extends State<GroupPlanPage> {
  String? _selectedFriends;
  String? _serialCode;
  final List<String> _dropdownItems = [
    '3 friends',
    '4 friends',
    '5 friends',
    '6 friends',
    '7 friends',
    '8 friends',
    '9 friends',
    '10 friends',
    '11 friends',
    '12 friends',
    '13 friends',
    '14 friends',
    '15 friends'
  ];

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
                            child: Text(month),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            _selectedMonth = value!;
                          });
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
                          setState(() {
                            _selectedYear = value!;
                          });
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
                backgroundColor: const Color.fromARGB(255, 94, 204, 255),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveSubscription(context, _cardNameController.text, _cardNumberController.text).then((_) {
                    Navigator.of(context).pop();
                  });
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
    String serialCode = _generateSerialCode();

    if (user != null) {
      final newSubscription = {
        'email': user.email,
        'date': DateTime.now().toIso8601String(),
        'subscription_type': 'Group Plan',
        'subscription_cost': '\$49.99',
        'subscription_duration': '1 Month',
        'subscription_exp_date': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        'card_holder_name': '${cardHolderName[0]}*****${cardHolderName.substring(cardHolderName.length - 5)}',
        'card_number': '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}',
        'serial_code': serialCode,
        'number_of_friends': _selectedFriends ?? 'N/A', // Handle null value
        'plan_name': 'Premium Fitness',
        'description': 'Access to premium fitness classes',
        'features': [
          'Personal trainer',
          'Nutrition plan'
        ],
      };

      await databaseRef.push().set(newSubscription);

      if (context.mounted) {
        setState(() {
          _serialCode = serialCode;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription successful!')),
        );
      }
    }
  }

  String _generateSerialCode() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();
    return String.fromCharCodes(Iterable.generate(10, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Image.network(
            'https://kajabi-storefronts-production.kajabi-cdn.com/kajabi-storefronts-production/file-uploads/themes/2155085722/settings_images/7a07fe-006a-47e6-d885-651cec38541d_2.jpg',
            height: 250.0,
            width: 250.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlanDetailsCard(
              title: 'Group Plan Details',
              details: const [
                'Plan Name: Premium Fitness',
                'Description: Access to premium fitness classes',
                'Price: \$49.99/month',
                'Features: Personal trainer, nutrition plan',
                'Number of Friends:',
              ],
              dropdownItems: _dropdownItems,
              onDropdownChanged: (value) {
                setState(() {
                  _selectedFriends = value;
                });
              },
              selectedValue: _selectedFriends,
            ),
            PlanDetailsCard(
              title: 'Serial Code Sharing',
              details: [
                'Your Serial Code: ${_serialCode ?? 'Not generated yet'}',
              ],
              hasButton: true,
              serialCode: _serialCode,
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 94, 204, 255),
                  textStyle: const TextStyle(fontSize: 20.0, color: Colors.white),
                  minimumSize: const Size(300.0, 50.0),
                ),
                child: const Text('Subscribe Now', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
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
              icon: const Icon(Icons.home, color: Colors.lightBlue),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class PlanDetailsCard extends StatelessWidget {
  final String title;
  final List<String> details;
  final List<String>? dropdownItems;
  final bool hasButton;
  final void Function(String?)? onDropdownChanged;
  final String? selectedValue;
  final String? serialCode;

  const PlanDetailsCard({
    super.key,
    required this.title,
    required this.details,
    this.dropdownItems,
    this.hasButton = false,
    this.onDropdownChanged,
    this.selectedValue,
    this.serialCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10.0),
          for (String detail in details)
            detail.contains(':')
                ? Text(detail, style: const TextStyle(fontSize: 16, color: Colors.black))
                : const SizedBox.shrink(),
          if (dropdownItems != null) ...[
            const SizedBox(height: 10.0),
            DropdownButton<String>(
              value: selectedValue,
              items: dropdownItems!
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: onDropdownChanged,
              hint: const Text('Select number of friends'),
            ),
          ],
          if (hasButton)
            const SizedBox(height: 10.0),
          if (hasButton)
            Center(
              child: ElevatedButton(
                onPressed: serialCode != null
                    ? () {
                        Clipboard.setData(ClipboardData(text: serialCode!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Serial Code copied to clipboard!')),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 94, 204, 255),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Copy Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
              ),
            ),
        ],
      ),
    );
  }
}