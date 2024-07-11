import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenithhabits/auth/auth.dart';
import 'package:zenithhabits/auth/login_or_register.dart';
import 'package:zenithhabits/data/entry_data.dart';
import 'package:zenithhabits/data/habit_data.dart';
import 'package:zenithhabits/firebase_options.dart';
import 'package:zenithhabits/pages/home_page.dart';
import 'package:zenithhabits/pages/profile_page.dart';
import 'package:zenithhabits/pages/today_page.dart';
import 'package:zenithhabits/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => HabitData()),
    ChangeNotifierProvider(
        create: (context) => EntryData()), // Provide EntryData
    ChangeNotifierProvider(
        create: (context) => ThemeProvider()) // Theme Provider
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
        // darkTheme: darkMode,
        routes: {
          '/login_register_page': (context) => const LoginOrRegister(),
          '/home_page': (context) => const HomePage(),
          '/profile_page': (context) => ProfilePage(),
          '/today_page': (context) => const TodayPage(),
        });
  }
}
