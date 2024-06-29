import 'package:flutter/material.dart';
import 'package:sfit/pages/FeedbackPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class PaymentPage extends StatefulWidget {
  final String coachName;
  final String coachSport;
  final String coachImage;
  final bool isLocalImage;

  const PaymentPage({
    super.key,
    required this.coachName,
    required this.coachSport,
    required this.coachImage,
    required this.isLocalImage,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? paymentOption;
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  LatLng? selectedLocation;
  bool isCardDetailsConfirmed = false;
  String _selectedMonth = '06';
  String _selectedYear = '24';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Coach: ${widget.coachName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            InkWell(
              onTap: () async {
                LatLng? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationPicker(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    selectedLocation = result;
                  });
                }
              },
              child: Container(
                height: 270,
                width: 110,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(
                    image: NetworkImage(
                      selectedLocation == null
                          ? 'https://images2.thanhnien.vn/528068263637045248/2024/4/20/google-maps-2-1713580278798-1713580279367384208041.jpg'
                          : 'https://storage0.dms.mpinteractiv.ro/media/401/341/5531/21708679/1/google-maps-2048x1149.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      selectedLocation == null
                          ? 'Pick a Location'
                          : 'Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pay with',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: const Icon(Icons.wallet_rounded),
                  title: const Text('Cash'),
                  trailing: Radio<String>(
                    value: 'Cash',
                    groupValue: paymentOption,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        paymentOption = value;
                        isCardDetailsConfirmed = false;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('Visa'),
                  trailing: Radio<String>(
                    value: 'Visa',
                    groupValue: paymentOption,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        paymentOption = value;
                        if (value == 'Visa') {
                          _showVisaPaymentDialog(context);
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Session Subtotal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$50',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (paymentOption == 'Visa') {
                    if (isCardDetailsConfirmed) {
                      _storeTransactionDetails(
                        context,
                        cardHolderNameController.text,
                        cardNumberController.text,
                        '$_selectedMonth/$_selectedYear',
                      );
                    }
                  } else if (paymentOption == 'Cash') {
                    _storeTransactionDetails(context, null, null, null);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5ECCFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showVisaPaymentDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: const [
              Icon(Icons.credit_card),
              SizedBox(width: 8),
              Text('Enter Card Details'),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: cardHolderNameController,
                  decoration: const InputDecoration(labelText: 'Card Holder Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the card holder name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Credit Card Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter credit card number';
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
                  controller: cvvController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'CVV'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter CVV';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 94, 204, 255),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    isCardDetailsConfirmed = true;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _storeTransactionDetails(BuildContext context, String? cardHolderName, String? cardNumber, String? expDate) async {
    try {
      String userEmail = FirebaseAuth.instance.currentUser!.email!;
      String? username = FirebaseAuth.instance.currentUser!.displayName;
      String currentDate = DateTime.now().toIso8601String();
      String transactionId = UniqueKey().toString();
      String coachName = widget.coachName;
      String coachSport = widget.coachSport;
      String coachImage = widget.coachImage;
      bool isLocalImage = widget.isLocalImage;
      String sessionSubtotal = '\$50'; // Update this value accordingly

      String paymentOptionText = paymentOption == 'Visa' ? 'Visa' : 'Cash';
      String maskedCardNumber = paymentOption == 'Visa'
          ? '**** **** **** ${cardNumber?.substring(cardNumber.length - 4)}'
          : 'N/A';

      DateTime now = DateTime.now();
      DateTime sessionStartTime = now.add(const Duration(hours: 1));
      DateTime sessionEndTime = sessionStartTime.add(const Duration(hours: 1));
      String location = selectedLocation != null ? '${selectedLocation!.latitude}, ${selectedLocation!.longitude}' : 'Unknown';

      DatabaseReference paymentRef = FirebaseDatabase.instance.reference().child('Payments').push();
      await paymentRef.set({
        'userEmail': userEmail,
        'username': username,
        'currentDate': currentDate,
        'transactionId': transactionId,
        'coachName': coachName,
        'coachSport': coachSport,
        'coachImage': coachImage,
        'isLocalImage': isLocalImage,
        'sessionSubtotal': sessionSubtotal,
        'paymentOption': paymentOptionText,
        'creditCardNumber': maskedCardNumber,
        'sessionDate': currentDate.substring(0, 10),
        'sessionStartTime': sessionStartTime.toIso8601String(),
        'sessionEndTime': sessionEndTime.toIso8601String(),
        'location': location,
        'cardHolderName': cardHolderName != null ? '${cardHolderName[0]}*****${cardHolderName.substring(cardHolderName.length - 5)}' : 'N/A',
        'subscription_exp_date': now.add(const Duration(days: 30)).toIso8601String(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackPage(coachName: widget.coachName),
        ),
      );
    } catch (e) {
      print("Error storing transaction details: $e");
      // Optionally, show an error message to the user
    }
  }
}

class LocationPicker extends StatelessWidget {
  const LocationPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
      ),
      body: FlutterLocationPicker(
        initZoom: 16,
        minZoomLevel: 5,
        maxZoomLevel: 18,
        trackMyPosition: true,
        searchBarBackgroundColor: Colors.white,
        onPicked: (pickedData) {
          Navigator.pop(context, LatLng(pickedData.latLong.latitude, pickedData.latLong.longitude));
        },
      ),
    );
  }
}
