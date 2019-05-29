import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsBlocError extends Error {
  final String message;

  PrefsBlocError(this.message);
}

class PrefsState {
  final bool showWebView;

  const PrefsState(this.showWebView);
}

class PrefsNotifier with ChangeNotifier {
  PrefsState _currentPrefs = PrefsState(false);

  bool get showWebView => _currentPrefs.showWebView;

  set showWebView(bool newValue) {
    if (newValue == _currentPrefs.showWebView) return;
    _currentPrefs = PrefsState(newValue);
    notifyListeners();
    _saveNewPrefs();
  }

  PrefsNotifier() {
    _loadSharedPrefs();
  }

  Future<void> _loadSharedPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var showWebView = sharedPrefs.getBool('showWebView') ?? false;
    _currentPrefs = PrefsState(showWebView);
    notifyListeners();
  }

  Future<void> _saveNewPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool('showWebView', _currentPrefs.showWebView);
  }
}
