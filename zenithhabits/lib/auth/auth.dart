import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zenithhabits/auth/login_or_register.dart';
import 'package:zenithhabits/pages/home_page.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           // user is logged in
//           if (snapshot.hasData) {
//             return const HomePage();
//           }

//           // user is NOT logged in
//           else {
//             return const LoginOrRegister();
//           }
//         },
//       ),
//     );
//   }
// }

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check for connection state and user data
          User? user = snapshot.data;

          // User is logged in and email is verified
          if (user != null && user.emailVerified) {
            return const HomePage();
          }

          // User is either not logged in or hasn't verified their email
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
