import 'package:flutter/material.dart';
import '../pages/Calendar/calendar.dart';

// MAIN SCREENS // - That show on navbar
final mainScreens = [
  Center(child: Text('Home', style: TextStyle(fontSize: 60))),
  MyCalendarPage(),
  Center(child: Text('Training', style: TextStyle(fontSize: 60))),
  Center(child: Text('Settings', style: TextStyle(fontSize: 60))),
];

//NAVIGATION WIDGET//
class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int currentNavIndex = 0;

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
