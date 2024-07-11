import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                // drawer header
                DrawerHeader(
                  child: Icon(Icons.favorite,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),

                const SizedBox(height: 25),

                // home tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                      leading: Icon(Icons.home,
                          color: Theme.of(context).colorScheme.inversePrimary),
                      title: const Text("H O M E"),
                      // this is already the home screen so just pop drawer
                      onTap: () {
                        Navigator.pop(context);
                      }),
                ),

                // profile tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                      leading: Icon(Icons.person,
                          color: Theme.of(context).colorScheme.inversePrimary),
                      title: const Text("P R O F I L E"),
                      // this is already the home screen so just pop drawer
                      onTap: () {
                        // pop drawer
                        Navigator.pop(context);

                        // navigate to profile page
                        Navigator.pushNamed(context, '/profile_page');
                      }),
                ),

                // today tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                      leading: Icon(Icons.timer,
                          color: Theme.of(context).colorScheme.inversePrimary),
                      title: const Text("T O D A Y"),
                      // this is already the home screen so just pop drawer
                      onTap: () {
                        // pop drawer
                        Navigator.pop(context);

                        // navigate to profile page
                        Navigator.pushNamed(context, '/today_page');
                      }),
                ),
              ]),
              // logout
              Padding(
                padding: const EdgeInsets.only(left: 25.0, bottom: 25),
                child: ListTile(
                    leading: Icon(Icons.home,
                        color: Theme.of(context).colorScheme.inversePrimary),
                    title: const Text("L O G O U T"),
                    // this is already the home screen so just pop drawer
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ),
            ]));
  }
}
