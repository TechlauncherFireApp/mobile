// ignore_for_file: prefer_const_constructors
import 'package:fireapp/pages/Authentication/register.dart';
import 'package:flutter/material.dart';
import 'pages/Calendar/calendar.dart';
import 'layout/wrapper.dart';
import 'layout/navigation.dart';
import 'package:fireapp/pages/Authentication/login.dart';

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
      initialRoute: '/login',
      routes: {
        //  (You can change it to the page you develop in the beginning)
        '/nav': (context) => MainRoute(), // See Layout/Navigation.dart
        '/login': (context) => const BasicWrapper(
            page: LoginPage()), // See Authentication/Login.dart
        '/register': (context) => const BasicWrapper(
            page: RegisterPage()), //See Authentication/register.dart
      },
    );
  }
}
