import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsBlocError extends Error {
  final String message;

  PrefsBlocError(this.message);
}

class PrefsState {
  final bool showWebView;
  final bool userSetDarkMode;

  const PrefsState({this.showWebView = false, this.userSetDarkMode = false});
}

class PrefsNotifier with ChangeNotifier {
  PrefsState _currentPrefs =
      PrefsState(showWebView: false, userSetDarkMode: false);

  PrefsNotifier() {
    _loadSharedPrefs();
  }

  bool get showWebView => _currentPrefs.showWebView;
  bool get userDarkMode => _currentPrefs.userSetDarkMode;

  set showWebView(bool newValue) {
    if (newValue == _currentPrefs.showWebView) return;
    _currentPrefs = PrefsState(showWebView: newValue);
    notifyListeners();
    _saveNewPrefs();
  }

  set userDarkMode(bool newValue) {
    if (newValue == _currentPrefs.userSetDarkMode) return;
    _currentPrefs = PrefsState(userSetDarkMode: newValue);
    notifyListeners();
    _saveNewPrefs();
  }

  Future<void> _loadSharedPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var showWebView = sharedPrefs.getBool('showWebView') ?? false;
    var userDarkMode = sharedPrefs.getBool('userDarkMode') ?? false;
    _currentPrefs =
        PrefsState(showWebView: showWebView, userSetDarkMode: userDarkMode);
    notifyListeners();
  }

  Future<void> _saveNewPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    // TODO(efortuna): Why is this a shared preferences variable?
    await sharedPrefs.setBool('showWebView', _currentPrefs.showWebView);
    await sharedPrefs.setBool('userDarkMode', _currentPrefs.userSetDarkMode);
  }
}
