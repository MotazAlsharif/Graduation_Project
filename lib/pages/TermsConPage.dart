import 'package:flutter/material.dart';
import 'package:sfit/pages/CoachSignUpPage.dart';


class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('\n Terms and Conditions'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20 ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.grey[200],
                child: const Text(
                  "Image copy rights Information about image ownership, usage rights, and attribution requirements.\n\nService agreement details on payment terms, service expectations, cancellation policies, and other relevant terms of service.\n\nAccess device location Explanation of the app's policy on accessing the user's device location.\n\nAccess device memory details on how the app interacts with the user's device memory.\n\nPrivacy policy Information on data collection practices, information sharing, security measures, and user rights regarding personal information.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,MaterialPageRoute(builder: (context) => const CoachSignUpPage()),);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Accept Terms & Conditions',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
