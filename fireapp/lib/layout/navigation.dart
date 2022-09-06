import 'package:flutter/material.dart';
import '../global/access.dart';
import '../pages/Calendar/calendar.dart';

Widget mainNav() {
  print(role);
  if (role == "VOLUNTEER") {
    // If logged in user is a supervisor then send them to the supervisor menu\
    return const VolunteerRoute();
  } else if (role == "ROOT_ADMIN") {
    return const SupervisorRoute();
  } else {
    return const VolunteerRoute();
  }
}

//NAVIGATION WIDGET FOR VOLUNTEER//
class VolunteerRoute extends StatefulWidget {
  const VolunteerRoute({super.key});

  @override
  State<VolunteerRoute> createState() => _VolunteerRouteState();
}

// Main Navigation Screens - For Volunteer (Will show on navbar)
final volunteerScreens = [
  Center(child: Text('Home', style: TextStyle(fontSize: 60))),
  MyCalendarPage(),
  Center(child: Text('Training', style: TextStyle(fontSize: 60))),
  Center(child: Text('Settings', style: TextStyle(fontSize: 60))),
];

class _VolunteerRouteState extends State<VolunteerRoute> {
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
        selectedIndex: currentNavIndex,
        onDestinationSelected: (index) =>
            setState(() => currentNavIndex = index),
      ),
      body: IndexedStack(
        index: currentNavIndex,
        children: volunteerScreens,
      ),
    );
  }
}

// FOR SUPERVISOR //
class SupervisorRoute extends StatefulWidget {
  const SupervisorRoute({super.key});

  @override
  State<SupervisorRoute> createState() => _SupervisorRouteState();
}

// Main Navigation Screens - For SuperVisor  (Will show on navbar)
final supervisorScreens = [
  Center(child: Text('Home', style: TextStyle(fontSize: 60))),
  MyCalendarPage(),
  Center(child: Text('Training', style: TextStyle(fontSize: 60))),
  Center(child: Text('Settings', style: TextStyle(fontSize: 60))),
];

class _SupervisorRouteState extends State<SupervisorRoute> {
  int currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Shifts',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: 'Volunteers',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedIndex: currentNavIndex,
        onDestinationSelected: (index) =>
            setState(() => currentNavIndex = index),
      ),
      body: IndexedStack(
        index: currentNavIndex,
        children: volunteerScreens,
      ),
    );
  }
}
