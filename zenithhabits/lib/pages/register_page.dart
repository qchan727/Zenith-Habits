import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zenithhabits/components/my_button.dart';
import 'package:zenithhabits/components/my_textfield.dart';
import 'package:zenithhabits/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();

  // register method
  void registerUser() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    // make sure passwords match
    if (passwordController.text != confirmPwController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser("Passwords don't match!", context);
    }
    // if passwords do match
    else {
      // try creating the user
      try {
        // create the user
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        final User? user = userCredential.user; // NOTE: NEW
        // displayMessageToUser(
        //     "Verification email sent. Please check your email.", context);

        // // pop loading circle
        // Navigator.pop(context);

        // create a user document and add to firestore
        createUserDocument(userCredential);

        if (user != null && !user.emailVerified) {
          // Send verification email
          await user.sendEmailVerification();

          // After sending verification email, pop the loading screen
          Navigator.pop(context);

          // Show a message or navigate
          displayMessageToUser(
              "Registered successfully. Please verify your email.", context);

          // Optionally, navigate the user to the login or an informational page
          // Navigator.pushReplacementNamed(context, '/loginOrInformationPage');
        }
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);

        // display error message to user
        displayMessageToUser(e.code, context);
      }
    }
  }

  // create a user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'lastResetTimestamp': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // logo
                        Icon(Icons.person,
                            size: 80,
                            color: Theme.of(context).colorScheme.inversePrimary),
          
                        const SizedBox(height: 25),
          
                        // app name
                        const Text("Z E N I T H     H A B I T S",
                            style: TextStyle(fontSize: 20)),
          
                        const SizedBox(height: 50),
          
                        // username textfield
                        MyTextField(
                            hintText: "Username",
                            obscureText: false,
                            controller: usernameController),
          
                        const SizedBox(height: 10),
          
                        // email textfield
                        MyTextField(
                            hintText: "Email",
                            obscureText: false,
                            controller: emailController),
          
                        const SizedBox(height: 10),
          
                        // password textfield
                        MyTextField(
                            hintText: "Password",
                            obscureText: true,
                            controller: passwordController),
          
                        const SizedBox(height: 10),
          
                        // confirm password textfield
                        MyTextField(
                            hintText: "Confirm Password",
                            obscureText: true,
                            controller: confirmPwController),
          
                        const SizedBox(height: 25),
          
                        // register button
                        MyButton(text: "Register", onTap: registerUser),
          
                        const SizedBox(height: 25),
          
                        // register here
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              GestureDetector(
                                  onTap: widget.onTap,
                                  child: const Text("Login Here",
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold)))
                            ]),
                      ]))),
        ));
  }
}
