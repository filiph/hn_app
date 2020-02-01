import 'package:flutter/material.dart';
import 'package:hn_app/src/notifiers/prefs.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: IconThemeData(
          color: Provider.of<PrefsNotifier>(context).userDarkMode == true
              ? Colors.white
              : Colors.black,
        ),
      ),
      body: Column(
        children: <Widget>[
          SwitchListTile(
            title: Text(
              'Use Dark Mode',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            activeColor: Colors.blue,
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
