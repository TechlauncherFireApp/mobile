// ignore_for_file: prefer_const_constructors
// EXTERNAL
import 'package:fireapp/global/di.dart';
import 'package:fireapp/pages/Supervisor/volunteerManagment.dart';
import 'package:fireapp/presentation/volunteer_list/volunteer_list.dart';
import 'package:flutter/material.dart';
//INTERNAL
import 'layout/wrapper.dart';
import 'layout/navigation.dart';
import 'package:fireapp/global/theme.dart';
import 'package:fireapp/pages/Authentication/register.dart';
import 'package:fireapp/pages/Authentication/login.dart';
import 'package:fireapp/pages/Authentication/reset_password/reset_email.dart';
import 'package:fireapp/pages/settings/setting.dart';

// Main Function
void main() {
  configureDependencies();
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
      theme: fireappTheme(),
      title: 'Flutter Demo',
      initialRoute: '/volunteer_list',
      routes: {
        //  (You can change it to the page you develop in the beginning)
        '/nav': (context) => mainNav(), // See Layout/Navigation.dart
        '/login': (context) => const BasicWrapperNoLead(
            page: LoginPage()), // See Authentication/Login.dart
        '/register': (context) => const BasicWrapper(
            page: RegisterPage()), //See Authentication/register.dart
        '/reset_password': (context) => const BasicWrapper(page: ResetPage()),
        '/volunteer_list': (context) => const VolunteerList()
      },
    );
  }
}
