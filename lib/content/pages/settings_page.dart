import 'package:asset_flutter/auth/pages/login_page.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {  
  bool _notificationSwitch = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Account'),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.email_rounded),
                title: const Text('Change email'),
                onPressed: (ctx) {
                  //TODO: Open dialog
                },
               ),
               SettingsTile.navigation(
                leading: const Icon(Icons.lock_rounded),
                title: const Text('Change password'),
                onPressed: (ctx) {
                  //TODO: Open dialog
                },
               ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Sign out'),
                onPressed: (ctx) {
                  SharedPref().deleteLoginCredentials();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => LoginPage()));
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Other'),
            tiles: [
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    _notificationSwitch = value;
                  });
                },
                initialValue: _notificationSwitch,
                leading: const Icon(Icons.notifications_active_rounded),
                title: const Text('Enable notifications'),
              ),
              CustomSettingsTile(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: TextButton(
                        child: const Text('Delete Account', style: TextStyle(color: Color(0xFF777777))),
                        onPressed: (){
                          //TODO: Implement
                          print("Delete pressed");
                        },
                      ),
                    ),
                  ],
                ), 
              )
            ],
          )
        ],
      ),
    );
  }
}
