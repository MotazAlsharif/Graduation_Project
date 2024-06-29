import 'package:flutter/material.dart';
import 'package:sfit/pages/FavoriteCoachesListPage.dart';
import 'package:sfit/pages/MySubscriptions.dart';
import 'package:sfit/pages/SubscriptionPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sfit/pages/LoginPage.dart';
import 'package:sfit/pages/Sessions.dart';

class MyDrawer extends StatelessWidget {
  final Map<String, dynamic>? userDetails;

  const MyDrawer({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    if (userDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String username = userDetails!['username'] ?? 'Username';
    String? profileImageUrl = userDetails!['profileImageUrl'];

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 20.0),
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl) : null,
                  backgroundColor: Colors.blue,
                  child: profileImageUrl == null
                      ? const Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(fontSize: 20.0),
                        overflow: TextOverflow.ellipsis, // Ensures text does not overflow
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        height: 1.0,
                        width: double.infinity,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sports_gymnastics_rounded),
            title: const Text('Sessions'),
            onTap: () {
              // Handle Sessions tap
               Navigator.push(context, MaterialPageRoute(builder: (context) => Sessions()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.sports_kabaddi_rounded),
            title: const Text('My Coaches'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteCoaches(title: 'My Favorite Coaches',)));
              // Handle Coaches tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_membership_rounded),
            title: const Text('Plans'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionPage()));
              // Handle Plans tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card_rounded),
            title: const Text('Subscriptions'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MySubscriptionsPage()));
              // Handle Subscriptions tap
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign out'),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              } catch (e) {
                print('Error signing out: $e');
              }
            },
          ),
        ],
      ),
    );
  }
}
