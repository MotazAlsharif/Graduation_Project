import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sfit/pages/Homepage.dart';

class FeedbackPage extends StatefulWidget {
  final String coachName;

  const FeedbackPage({super.key, required this.coachName});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int selectedStars = 0;
  String feedback = '';

  final databaseReference = FirebaseDatabase.instance.reference();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Congratulations!",
                style: TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Container(
                height: 1.0,
                width: 800.0,
                color: const Color.fromARGB(255, 120, 120, 120),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              const Text(
                "How was your experience?",
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50.0),
              const Text(
                "Rate Your Experience",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 5; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedStars = i + 1;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: i < selectedStars
                              ? const Color.fromARGB(255, 116, 220, 255)
                              : Colors.grey,
                          size: 43.0,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tell us more about your experience",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      onChanged: (value) {
                        feedback = value;
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Share your experience here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () async {
                  if (user != null) {
                    String username = user!.displayName ?? 'Anonymous';
                    String email = user!.email ?? 'No email';

                    try {
                      await databaseReference.child("Feedback").push().set({
                        'Stars Rating': selectedStars,
                        'Feedback message': feedback,
                        'Trainee Username': username,
                        'Trainee Email': email,
                        'Coach name': widget.coachName,
                      });

                      // Fetch user details
                      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('trainees').child(user!.uid);
                      DataSnapshot snapshot = await userRef.get();
                      Map<String, dynamic> userDetails = {};
                      if (snapshot.value != null) {
                        userDetails = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
                      }

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SportsCoachesPage(userDetails: userDetails)),
                        );
                      }
                    } catch (e) {
                      print("Error saving feedback: $e");
                      // Optionally, show an error message to the user
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:const Color.fromARGB(255, 94, 204, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 18.0),
                ),
                child: const Text(
                  "Done!",
                  style: TextStyle(
                    fontSize: 16,
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
}
