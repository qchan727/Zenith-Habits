import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenithhabits/theme/theme_provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // current logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // error
            else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            // data received
            else if (snapshot.hasData) {
              // extract data
              Map<String, dynamic>? user = snapshot.data?.data();

              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      children: [
                        // profile pic
                        Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.all(25),
                            child: const Icon(Icons.person, size: 64)),

                        const SizedBox(height: 25),

                        // username
                        Text(user!['username'],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),

                        // email
                        Text(user['email'],
                            style: TextStyle(color: Colors.grey[600])),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // dark mode
                            Text("Dark Mode",
                                style: TextStyle(color: Colors.grey[600])),
                            // switch toggle
                            CupertinoSwitch(
                                value: Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .isDarkMode,
                                onChanged: (value) =>
                                    Provider.of<ThemeProvider>(context,
                                            listen: false)
                                        .toggleTheme()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Text("No data");
            }
          },
        ));
  }
}
