import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:sfit/pages/LoginPage.dart';
import 'package:sfit/pages/GuardianSetup.dart';
import 'package:sfit/pages/ChooseDisabilityPage.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        child: SignUpForm(),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  String? _imageUrl;
  String? _firstName;
  String? _lastName;
  int? _day;
  int? _month;
  int? _year;
  String? _phoneNumber;
  String? _email;
  String? _username;
  String? _password;
  String? _repeatPassword;
  bool _individualWithUniqueAbilities = false;
  bool _guardianForTrainees = false;
  bool _obscurePassword = true;
  List<Map<String, dynamic>> _juniorTrainees = [];
  String? _uniqueAbility;

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
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: CircleAvatar(
                radius: 70,
                backgroundColor: const Color.fromARGB(255, 94, 204, 255), // Blue background color
                child: _image != null
                    ? ClipOval(
                        child: Image.file(
                          _image!,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person, size: 70, color: Colors.white), // White icon color
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Sign up',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: _inputDecoration('First name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                } else if (value.length < 3) {
                  return 'First name must be at least 3 characters';
                } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                  return 'First name can only contain letters';
                }
                return null;
              },
              onSaved: (value) {
                _firstName = value;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: _inputDecoration('Last name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                } else if (value.length < 3) {
                  return 'Last name must be at least 3 characters';
                } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                  return 'Last name can only contain letters';
                }
                return null;
              },
              onSaved: (value) {
                _lastName = value;
              },
            ),
            const SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Birthdate'),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        items: List.generate(31, (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}'),
                          );
                        }),
                        decoration: _inputDecoration('Day'),
                        onChanged: (int? value) {},
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a day';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _day = value;
                        },
                        isExpanded: true,
                        // dropdownWidth: 100, // Uncomment this line to set a fixed width
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        items: List.generate(12, (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}'),
                          );
                        }),
                        decoration: _inputDecoration('Month'),
                        onChanged: (int? value) {},
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a month';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _month = value;
                        },
                        isExpanded: true,
                        // dropdownWidth: 100, // Uncomment this line to set a fixed width
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        items: List.generate(DateTime.now().year - 1970 + 1, (index) {
                          return DropdownMenuItem(
                            value: DateTime.now().year - index,
                            child: Text('${DateTime.now().year - index}'),
                          );
                        }),
                        decoration: _inputDecoration('Year'),
                        onChanged: (int? value) {},
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a year';
                          } else if (DateTime.now().year - value < 18) {
                            return 'You must be at least 18 years old';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _year = value;
                        },
                        isExpanded: true,
                        // dropdownWidth: 100, // Uncomment this line to set a fixed width
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: _inputDecoration('Phone number').copyWith(
                prefixText: '+962 ',
                suffixIcon: const Icon(Icons.call),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                } else if (value.length < 10 || value.length > 14) {
                  return 'Phone number must be between 10 and 14 digits';
                }
                return null;
              },
              onSaved: (value) {
                _phoneNumber = value;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: _inputDecoration('Email').copyWith(
                suffixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!value.contains('@')) {
                  return 'Please enter a valid email address';
                } else if (value.length < 12) {
                  return 'Email must be at least 12 characters long';
                }
                return null;
              },
              onSaved: (value) {
                _email = value;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: _inputDecoration('Create a username').copyWith(
                suffixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                } else if (value.length < 5) {
                  return 'Username must be at least 5 characters';
                } else if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  return 'Special characters are not allowed';
                }
                return null;
              },
              onSaved: (value) {
                _username = value;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: _inputDecoration('Create password').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                } else if (value.length < 8 || value.length > 30) {
                  return 'Password must be between 8 and 30 characters';
                } else if (!RegExp(r'^(?=.*?[0-9@]).{8,}$').hasMatch(value)) {
                  return 'Password must contain a number or symbol';
                }
                return null;
              },
              onChanged: (value) {
                _password = value;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: _inputDecoration('Repeat password').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please repeat your password';
                } else if (value != _password) {
                  return 'Passwords do not match';
                }
                return null;
              },
              onChanged: (value) {
                _repeatPassword = value;
              },
            ),
            const SizedBox(height: 10.0),
            CheckboxListTile(
              title: const Text('Individual with unique abilities'),
              value: _individualWithUniqueAbilities,
              onChanged: (newValue) async {
                if (newValue == true) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChooseDisabilityPage(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _uniqueAbility = result;
                    });
                  }
                }
                setState(() {
                  _individualWithUniqueAbilities = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Guardian for trainees?'),
              value: _guardianForTrainees,
              onChanged: (newValue) async {
                setState(() {
                  _guardianForTrainees = newValue!;
                });
                if (_guardianForTrainees) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GuardianSetupPage(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _juniorTrainees = result;
                    });
                  }
                }
              },
            ),
            SizedBox(
              width: 120.0, // Adjust the width as needed
              height: 50.0, // Adjust the height as needed
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 94, 204, 255), // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners
                  ),
                  minimumSize: const Size(120, 50), // Minimum size
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _signUp();
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      try {
        final firebase_storage.Reference storageRef =
            firebase_storage.FirebaseStorage.instance.ref().child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_image!);
        _imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email!,
        password: _password!,
      );
      User? user = userCredential.user;

      if (user != null) {
        DatabaseReference databaseRef = FirebaseDatabase.instance.reference().child('trainees').child(user.uid);
        await databaseRef.set({
          'firstName': _firstName,
          'lastName': _lastName,
          'day': _day,
          'month': _month,
          'year': _year,
          'phoneNumber': _phoneNumber,
          'email': _email,
          'username': _username,
          'password': _password,
          'individualWithUniqueAbilities': _individualWithUniqueAbilities,
          'uniqueAbility': _uniqueAbility, 
          'guardianForTrainees': _guardianForTrainees,
          'profileImageUrl': _imageUrl,
          'juniorTrainees': _juniorTrainees,
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    } catch (e) {
      print('Error signing up: $e');
    }
  }
}