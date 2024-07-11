import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zenithhabits/components/my_button.dart';
import 'package:zenithhabits/components/my_textfield.dart';
import 'package:zenithhabits/helper/helper_functions.dart';
import 'package:zenithhabits/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  // login method
  void login() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    // try sign in
    try {
      // await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text); // NOTE: NEW

      // pop loading circle
      if (context.mounted) Navigator.pop(context);
      // await userCredential.user?.reload(); //NOTE: NEW
      final User? user = userCredential.user;

      // NOTE: NEW
      if (user != null && !user.emailVerified) {
        // If user is not verified, show a message and don't log them in
        await user.sendEmailVerification();
        displayMessageToUser(
            "Please verify your email before logging in.", context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }

    // display any errors
    on FirebaseAuthException catch (e) {
      // pop loading circle
      // Navigator.pop(context);
      // displayMessageToUser(e.code, context);

      if (e.code == 'too-many-requests') {
        displayMessageToUser(
            "Too many requests. Please wait a while before trying again.",
            context);
      } else {
        if (context.mounted) Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
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

                      const SizedBox(height: 25),

                      // sign in button
                      MyButton(text: "Login", onTap: login),

                      const SizedBox(height: 25),

                      // register here
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                                onTap: widget.onTap,
                                child: const Text("Register Here",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                          ]),
                    ]))));
  }
}
