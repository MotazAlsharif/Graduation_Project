import 'package:flutter/material.dart';

class GuardianSetupPage extends StatefulWidget {
  const GuardianSetupPage({super.key});

  @override
  _GuardianSetupPageState createState() => _GuardianSetupPageState();
}

class _GuardianSetupPageState extends State<GuardianSetupPage> {
  final List<Map<String, dynamic>> _juniorTrainees = [];
  String? _juniorName;
  String? _juniorGender;
  int? _juniorAge;
  int? _editingIndex;

  void _addOrUpdateJunior() {
    if (_juniorName != null && _juniorGender != null && _juniorAge != null) {
      setState(() {
        if (_editingIndex == null) {
          _juniorTrainees.add({
            'name': _juniorName,
            'gender': _juniorGender,
            'age': _juniorAge,
            'avatarUrl': _getAvatarUrl(_juniorGender!, _juniorAge!),
          });
        } else {
          _juniorTrainees[_editingIndex!] = {
            'name': _juniorName,
            'gender': _juniorGender,
            'age': _juniorAge,
            'avatarUrl': _getAvatarUrl(_juniorGender!, _juniorAge!),
          };
          _editingIndex = null;
        }
        _clearForm();
      });
    }
  }

  void _editJunior(int index) {
    setState(() {
      _juniorName = _juniorTrainees[index]['name'];
      _juniorGender = _juniorTrainees[index]['gender'];
      _juniorAge = _juniorTrainees[index]['age'];
      _editingIndex = index;
    });
  }

  void _clearForm() {
    _juniorName = null;
    _juniorGender = null;
    _juniorAge = null;
  }

  String _getAvatarUrl(String gender, int age) {
    if (gender == 'Male') {
      if (age > 12) {
        return 'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/batman_hero_avatar_comics-1024.png';
      } else {
        return 'https://www.clipartmax.com/png/full/405-4050774_avatar-icon-flat-icon-shop-download-free-icons-for-avatar-icon-flat.png';
      }
    } else {
      if (age > 12) {
        return 'https://cdn.icon-icons.com/icons2/1736/PNG/512/4043251-avatar-female-girl-woman_113291.png';
      } else {
        return 'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/girl_avatar_child_kid-512.png';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "SportConnect",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _juniorTrainees);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Junior Trainee Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: const Color.fromARGB(255, 223, 223, 223),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(labelText: "Junior Trainee Name"),
                        onChanged: (value) {
                          _juniorName = value;
                        },
                        controller: TextEditingController(text: _juniorName),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Junior Trainee Gender"),
                        items: ['Male', 'Female'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _juniorGender = value;
                        },
                        value: _juniorGender,
                      ),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(labelText: "Junior Trainee Age"),
                        items: List.generate(13, (index) {
                          return DropdownMenuItem<int>(
                            value: index + 5,
                            child: Text('${index + 5}'),
                          );
                        }),
                        onChanged: (value) {
                          _juniorAge = value;
                        },
                        value: _juniorAge,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _addOrUpdateJunior,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          _editingIndex == null ? "Add Junior Trainee" : "Update Junior Trainee",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Junior Trainees List",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._juniorTrainees.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> trainee = entry.value;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      _getAvatarUrl(trainee['gender'], trainee['age']),
                    ),
                    radius: 20,
                  ),
                  title: Text('${index + 1}. ${trainee['name']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _editJunior(index);
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _juniorTrainees.removeAt(index);
                          });
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, _juniorTrainees);
          },
          backgroundColor: Colors.blue,
          child: const Text(
            "Next",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
