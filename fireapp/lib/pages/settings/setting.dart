import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/global/access.dart';
import 'package:fireapp/pages/settings/accountDetails.dart';
import 'package:fireapp/pages/settings/dietaryPage.dart';
import 'package:fireapp/pages/settings/reset_pw_simple.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatelessWidget {
  final String email;
  SettingPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SettingBox(
          email: email,
        )),
      ],
    );
  }
}

class SettingBox extends StatefulWidget {
  final String email;
  SettingBox({Key? key, required this.email}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingBox> {

  // Add modern concept to legacy stuff
  final AuthenticationRepository _authenticationRepository =
    GetIt.instance.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings'), automaticallyImplyLeading: false),
      body: SettingsList(sections: [
        SettingsSection(
          title: Text('Application Settings'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.language),
              title: Text('Language'),
              value: Text('English'),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: false,
              leading: Icon(Icons.format_paint),
              title: Text('Enable dark mode'),
            ),
          ],
        ),
        SettingsSection(
          title: Text('Account Details'),
          // titleTextStyle: TextStyle(fontSize: 30),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
                leading: const Icon(Icons.password),
                title: const Text('Reset Password'),
                onPressed: (_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResetSimplePage(email: widget.email)),
                  );
                }),
            SettingsTile.navigation(
                leading: Icon(Icons.account_circle),
                title: Text('Update Account Details'),
                onPressed: (_) async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountDetailsPage()),
                  );
                }),
            SettingsTile.navigation(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onPressed: (_) {
                _authenticationRepository.logout();
                Navigator.popUntil(context, (route) => true);
                Navigator.pushNamed(context, "/login");
              }
            ),
          ],
        ),
        SettingsSection(
          title: const Text('User Information'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
                leading: const Icon(Icons.local_dining),
                title: const Text('Dietary Requirements'),
                onPressed: (_) async {
                  await Navigator.pushNamed(
                    context,
                    '/dietary_requirements/update',
                  );
                }),
            SettingsTile.navigation(
                leading: const Icon(Icons.health_and_safety),
                title: const Text('Medical Details'),
                onPressed: (_) {
                  // TODO: Medical Details
                }),
          ],
        ),
        SettingsSection(
          title: Text('Support'),
          // titleTextStyle: TextStyle(fontSize: 30),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
                leading: Icon(Icons.quiz),
                title: Text('FAQ'),
                onPressed: (_) {
                  // TODO: Contact Supervisor / Support
                }),
            SettingsTile.navigation(
                leading: Icon(Icons.contact_support),
                title: Text('Contact Supervisor / Support'),
                onPressed: (_) {
                  // TODO: Contact Supervisor / Support
                }),
          ],
        ),
      ]),
    );
  }
}
