import 'package:fireapp/pages/settings/setting.dart';
import 'package:flutter/material.dart';
import '../global/access.dart';
import '../pages/Calendar/calendar.dart';

Widget mainNav() {
  print(role);
  switch (role) {
    case "VOLUNTEER":
      return const VolunteerRoute();
    case "ROOT_ADMIN":
      return const SupervisorRoute();
    default:
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
  const Center(child: Text('Home', style: TextStyle(fontSize: 60))),
  const MyCalendarPage(),
  const Center(child: Text('Training', style: TextStyle(fontSize: 60))),
  SettingPage(email: userEmail),
];

class _VolunteerRouteState extends State<VolunteerRoute> {
  int currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.event_available),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Training',
          ),
          NavigationDestination(
            icon: Icon(Icons.manage_accounts_outlined),
            selectedIcon: Icon(Icons.manage_accounts),
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
            icon: Icon(Icons.pending_actions_outlined),
            selectedIcon: Icon(Icons.pending_actions_sharp),
            label: 'Shifts',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule),
            selectedIcon: Icon(Icons.watch_later),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            // Group icon vs Groups - unsure
            label: 'Volunteers',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
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
