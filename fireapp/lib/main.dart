// ignore_for_file: prefer_const_constructors
// EXTERNAL
import 'package:fireapp/environment_config.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/server_url/server_url_page.dart';
import 'package:fireapp/pages/Supervisor/schedulerForm.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view.dart';
import 'package:fireapp/pages/Supervisor/schedulerForm.dart';
import 'package:fireapp/presentation/shift_request/ShiftRequestPage.dart';
import 'package:fireapp/presentation/volunteer_information/volunteer_information.dart';
import 'package:fireapp/presentation/login/login_page.dart';
import 'package:fireapp/presentation/register/register_page.dart';
import 'package:fireapp/presentation/volunteer_list/volunteer_list.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_page.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/fireapp_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//INTERNAL
import 'firebase/firebase_api.dart';
import 'domain/repository/authentication_repository.dart';
import 'firebase_options.dart';
import 'layout/wrapper.dart';
import 'layout/navigation.dart';
import 'package:fireapp/global/theme.dart';
import 'package:fireapp/pages/Authentication/reset_password/reset_email.dart';
import 'package:fireapp/pages/settings/setting.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'main_view_model.dart';

// Main Function
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// Material App - App Basis
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MainViewModel viewModel = GetIt.instance.get();

  @override
  void initState() {
    super.initState();
    viewModel.setupTokenListener();
  }

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
      initialRoute: (EnvironmentConfig.serviceUrl.isEmpty) ? '/server_url_page' : '/login',
      routes: {
        //  (You can change it to the page you develop in the beginning)
        '/nav': (context) => mainNav(), // See Layout/Navigation.dart
        '/login': (context) => const LoginPage(), // See Authentication/Login.dart
        '/register': (context) => const RegisterPage(), //See Authentication/register.dart
        '/reset_password': (context) => const ResetPage(),
        '/volunteer_list': (context) => const VolunteerList(),
        '/dietary_requirements/update': (context) => const DietaryRequirementsPage(),
        '/server_url_page': (context) => const ServerUrlPage(),
        '/shift_request/{id}': (context) => const ShiftRequestView(requestId: "1"),
        '/constraint_form': (context) => const SchedulerConstraintPage(),
      },
    );
  }
}
