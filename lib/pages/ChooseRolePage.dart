import 'package:flutter/material.dart';
import 'package:sfit/pages/CoachSignUpPage.dart';
import 'package:sfit/pages/TraineeSignUpPage.dart';
import 'package:sfit/pages/LoginPage.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({super.key});

  @override
  _ChooseRolePageState createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  String selectedRole = 'Select'; // Default selection is 'Select'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80.0,
              backgroundImage: NetworkImage(
                  'https://assets-global.website-files.com/57822c659e1627a433e6a7c6/5f8011d3b0cad53a62d51710_5e4125fce8a6bf3c81feeb9d_Personal%2520Trainer.png'),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Choose Your Role",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50.0), // Added space here
            Container(
              width: 400.0, // Set the width of the container
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.lightBlue),
              ),
              child: DropdownButton<String>(
                value: selectedRole,
                onChanged: (String? value) {
                  if (value != 'Select') {
                    setState(() {
                      selectedRole = value!;
                    });
                  }
                },
                items: <String>['Select', 'Trainee', 'Coach']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                underline: Container(), // Remove the default underline
                isExpanded: true, // Make the dropdown button fill the width of its parent
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 22.0,
                iconEnabledColor: Colors.black,
                hint: const Text('Select', style: TextStyle(color: Colors.black)),
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
                dropdownColor: Colors.white, // Set the background color of the dropdown menu
              ),
            ),
            const SizedBox(height: 60.0), // Added space here
            ElevatedButton(
              onPressed: () {
                // Check the selected role and navigate accordingly
                if (selectedRole == 'Trainee') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                } else if (selectedRole == 'Coach') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CoachSignUpPage()),
                  );
                } else {
                  // Do nothing if the role is 'Select'
                  print('Please select a role');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 94, 204, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 18.0),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold, // Set the text to bold
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Add space between the button and the login text
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5.0), // Add space between the texts
                  Text(
                    "Login here.",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
