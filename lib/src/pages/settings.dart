import 'package:flutter/material.dart';
import 'package:hn_app/src/notifiers/prefs.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final Animation<double> initialAnimation;

  const SettingsPage(this.initialAnimation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: initialAnimation,
      builder: (context, dynamic value, child) {
        return Theme(
          data: ThemeData(
              canvasColor:
                  ColorTween(begin: Color(0x00FFFFFF), end: Colors.white)
                      .transform(value)),
          child: child!,
        );
      },
      child: Scaffold(
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
      ),
    );
  }
}
