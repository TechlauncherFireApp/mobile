// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'pages/calendar.dart';

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
      home: MainNavigation(),
    );
  }
}

//Main Navigation
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentAppBarIndex = 0;

  final screens = [
    Center(child: Text('Home', style: TextStyle(fontSize: 60))),
    const CalendarPage(),
    Center(child: Text('Training', style: TextStyle(fontSize: 60))),
    Center(child: Text('Settings', style: TextStyle(fontSize: 60))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: currentAppBarIndex,
        backgroundColor: Colors.red,
        selectedItemColor: Colors.white,
        iconSize: 30,
        onTap: (index) => setState(() => currentAppBarIndex = index),
      ),
      body: screens[currentAppBarIndex],
    );
  }
}

/*
ToDo:
1. Refactor navigation so that it uses Routes & IndexedStack 
see:
https://medium.com/@theboringdeveloper/common-bottom-navigation-bar-flutter-e3693305d2d
https://api.flutter.dev/flutter/widgets/IndexedStack-class.html
https://maheshmnj.medium.com/everything-about-the-bottomnavigationbar-in-flutter-e99e5470dddb
https://www.bradcypert.com/flutter-routing-inside-of-the-scaffold/
https://codewithandrea.com/articles/multiple-navigators-bottom-navigation-bar/
https://blog.logrocket.com/how-to-build-a-bottom-navigation-bar-in-flutter/

2. Integrate with Login Page, etc

*/
