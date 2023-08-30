// ignore_for_file: prefer_const_constructors
// EXTERNAL
import 'package:fireapp/global/di.dart';
import 'package:fireapp/pages/Supervisor/schedulerForm.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view.dart';
import 'package:fireapp/presentation/volunteer_information/volunteer_information.dart';
import 'package:fireapp/presentation/login/login_page.dart';
import 'package:fireapp/presentation/register/register_page.dart';
import 'package:fireapp/presentation/volunteer_list/volunteer_list.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_page.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/fireapp_app_bar.dart';
import 'package:flutter/material.dart';
//INTERNAL
import 'layout/wrapper.dart';
import 'layout/navigation.dart';
import 'package:fireapp/global/theme.dart';
import 'package:fireapp/pages/Authentication/reset_password/reset_email.dart';
import 'package:fireapp/pages/settings/setting.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Main Function
void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: theme(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      title: 'FireApp',
      initialRoute: '/constraint_form',

      routes: {
        //  (You can change it to the page you develop in the beginning)
        '/nav': (context) => mainNav(), // See Layout/Navigation.dart
        '/login': (context) => const LoginPage(), // See Authentication/Login.dart
        '/register': (context) => const RegisterPage(), //See Authentication/register.dart
        '/reset_password': (context) => const ResetPage(),
        '/volunteer_list': (context) => const VolunteerList(),
        '/dietary_requirements/update': (context) => const DietaryRequirementsPage(),
        '/constraint_form': (context) => const ConstraintFormRoute(),

      },
    );
  }
}
