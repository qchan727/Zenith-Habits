import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zenithhabits/auth/login_or_register.dart';
import 'package:zenithhabits/pages/globals.dart';
import 'package:zenithhabits/pages/journal_page.dart';
import 'package:zenithhabits/pages/profile_page.dart';
import 'package:zenithhabits/pages/stats_page.dart';
import 'package:zenithhabits/pages/today_page.dart';
import 'package:zenithhabits/data/habit_data.dart';
// import 'package:zenithhabits/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    habitData.checkAndRecordCompletion(); // Also check on app start
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App is resumed - check and record completion
      habitData.checkAndRecordCompletion();
    }
  }

  // logout user
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // After logging out, navigate back to the AuthPage or Login Page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const TodayPage(),
    const JournalPage(),
    const StatsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "Z E N I T H     H A B I T S",
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            elevation: 0,
            actions: [
              // logout button
              IconButton(
                  // onPressed: logout,
                  // icon: const Icon(
                  //   Icons.logout,
                  // )),
                  onPressed: () => logout(context),
                  icon: const Icon(
                    Icons.logout,
                  )),
            ]),
        // drawer: const MyDrawer(),
        body: _pages[_selectedIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(45.0), // Adjust the radius as needed
            topRight: Radius.circular(45.0), // Adjust the radius as needed
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _navigateBottomBar,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            selectedItemColor: Theme.of(context).colorScheme.background,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding:
                      EdgeInsets.only(top: 8.0), // Adjust the padding as needed
                  child: Icon(Icons.today),
                ),
                label: 'Today',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding:
                      EdgeInsets.only(top: 8.0), // Adjust the padding as needed
                  child: Icon(Icons.book),
                ),
                label: 'Journal',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding:
                      EdgeInsets.only(top: 8.0), // Adjust the padding as needed
                  child: Icon(Icons.bar_chart),
                ),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding:
                      EdgeInsets.only(top: 8.0), // Adjust the padding as needed
                  child: Icon(Icons.person),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}
