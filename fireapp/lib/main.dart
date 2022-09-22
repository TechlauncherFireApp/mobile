// ignore_for_file: prefer_const_constructors
// EXTERNAL
import 'package:flutter/material.dart';
//INTERNAL
import 'layout/wrapper.dart';
import 'layout/navigation.dart';
import 'package:fireapp/global/theme.dart';
import 'package:fireapp/pages/Authentication/register.dart';
import 'package:fireapp/pages/Authentication/login.dart';
import 'package:fireapp/pages/reset_password/reset_email.dart';
import 'package:fireapp/pages/reset_password/reset_password.dart';
import 'package:fireapp/pages/reset_password/reset_with_code.dart';
import 'package:fireapp/pages/settings/setting.dart';

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
      routes: {
        //  (You can change it to the page you develop in the beginning)
        '/nav': (context) => mainNav(), // See Layout/Navigation.dart
        '/login': (context) => const BasicWrapper(
            page: LoginPage()), // See Authentication/Login.dart
        '/register': (context) => const BasicWrapper(
            page: RegisterPage()), //See Authentication/register.dart
        '/reset_password': (context) => const BasicWrapper(page: ResetPage()),
        '/setting': (context) =>
            BasicWrapper(page: SettingPage(email: "julia1412@163.com")),
      },
    );
  }
}
