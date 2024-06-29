import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Sessions extends StatefulWidget {
  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  List<Map<String, dynamic>> sessions = [];

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference sessionsRef = FirebaseDatabase.instance.reference().child('Payments');
      sessionsRef.orderByChild('userEmail').equalTo(user.email).onValue.listen((event) {
        if (!mounted) return; // Ensure this state is still mounted before calling setState
        final data = event.snapshot.value;
        if (data != null && data is Map<dynamic, dynamic>) {
          setState(() {
            sessions = (data.values as Iterable).map((e) => Map<String, dynamic>.from(e)).toList();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Add any additional cleanup logic if necessary
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('My Sessions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return SessionCard(
            coachName: session['coachName'] ?? 'Unknown',
            coachSport: session['coachSport'] ?? 'Unknown',
            sessionDate: session['sessionDate'] ?? 'Unknown',
            sessionStartTime: session['sessionStartTime'] ?? 'Unknown',
            sessionEndTime: session['sessionEndTime'] ?? 'Unknown',
            location: session['location'] ?? 'Unknown',
            coachImage: session['coachImage'] ?? '',
            isLocalImage: session['isLocalImage'] ?? false,
          );
        },
      ),
    );
  }
}

class SessionCard extends StatefulWidget {
  final String coachName;
  final String coachSport;
  final String sessionDate;
  final String sessionStartTime;
  final String sessionEndTime;
  final String location;
  final String coachImage;
  final bool isLocalImage;

  const SessionCard({
    super.key,
    required this.coachName,
    required this.coachSport,
    required this.sessionDate,
    required this.sessionStartTime,
    required this.sessionEndTime,
    required this.location,
    required this.coachImage,
    required this.isLocalImage,
  });

  @override
  _SessionCardState createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  bool isMinimized = false;
  bool isCompleted = false;
  bool isCancelled = false;

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    if (isCompleted) {
      cardColor = Colors.green;
    } else if (isCancelled) {
      cardColor = Colors.red;
    } else {
      cardColor = const Color.fromARGB(211, 211, 211, 211);
    }

    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMinimized) ...[
              CircleAvatar(
                backgroundImage: widget.isLocalImage ? AssetImage(widget.coachImage) : NetworkImage(widget.coachImage) as ImageProvider,
                radius: 40,
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.coachSport,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Coach: ${widget.coachName}',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Session Date: ${widget.sessionDate}',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Session Time: ${widget.sessionStartTime.substring(11, 16)} - ${widget.sessionEndTime.substring(11, 16)}',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Location: ${widget.location}',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
              ),
            ] else ...[
              CircleAvatar(
                backgroundImage: widget.isLocalImage ? AssetImage(widget.coachImage) : NetworkImage(widget.coachImage) as ImageProvider,
                radius: 20,
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.coachSport,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ],
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        isCompleted = true;
                        isCancelled = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Session Completed!')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        isCompleted = false;
                        isCancelled = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Session Cancelled!')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(isMinimized ? Icons.expand_more : Icons.expand_less),
                    onPressed: () {
                      setState(() {
                        isMinimized = !isMinimized;
                      });
                    },
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
