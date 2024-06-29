import 'package:flutter/material.dart';


class GetHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
         backgroundColor: Colors.white,
        title: Text('Get Help'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            {
            Navigator.pop(context);
          }
            // Add your back button action here
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'How Can I Help You?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your problem here',
                ),
                maxLines: 4,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                              {
            Navigator.pop(context);
          }
                  // Add your submit button action here
                },
                child: Text('Submit',style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )
),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 94, 204, 255)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}