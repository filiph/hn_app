import 'package:flutter/material.dart';
import 'package:hn_app/src/notifiers/prefs.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text('Use Dark Mode'),
          Switch(
            value: Provider.of<PrefsNotifier>(context).userDarkMode,
            onChanged: (bool newValue) {
              Provider.of<PrefsNotifier>(context).userDarkMode = newValue;
            },
          ),
        ],
      ),
    );
  }
}
