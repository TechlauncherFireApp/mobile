// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'pages/Calendar/calendar.dart';
import 'layout/wrapper.dart';
import 'package:fireapp/pages/login.dart';

// Main Function
void main() {
  runApp(const MyApp());
}

// Material App - App Basis
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        // Change the primary color of all the widget in red
        primarySwatch: Colors.red,
      ),
      // The current root page is login page
      initialRoute: '/nav',
      routes: {
        //  (You can change it to the page you develop in the beginning)
        '/nav': (context) => MainRoute(),
        '/login': (context) => const BasicWrapper(page: LoginPage()),
      },
    );
  }
}

//Main Navigation
class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int currentNavIndex = 0;

  final mainScreens = [
    Center(child: Text('Home', style: TextStyle(fontSize: 60))),
    const CalendarPage(),
    Center(child: Text('Training', style: TextStyle(fontSize: 60))),
    Center(child: Text('Settings', style: TextStyle(fontSize: 60))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Icon(Icons.school),
              label: 'Training',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          //type: BottomNavigationBarType.fixed,
          selectedIndex: currentNavIndex,
          //backgroundColor: Colors.red,
          //selectedItemColor: Colors.white,
          //iconSize: 30,
          onDestinationSelected: (index) =>
              setState(() => currentNavIndex = index),
        ),
        body: IndexedStack(
          index: currentNavIndex,
          children: mainScreens,
        )
        //screens[currentAppBarIndex],
        );
  }
}
