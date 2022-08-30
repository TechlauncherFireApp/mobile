// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'pages/Calendar/calendar.dart';

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
      home: MainRoute(),
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
https://stackoverflow.com/questions/69894199/flutter-fix-bottom-navigation-bar-in-whole-app

2. Integrate with Login Page, etc

*/
