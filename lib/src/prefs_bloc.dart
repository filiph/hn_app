import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsBlocError extends Error {
  final String message;

  PrefsBlocError(this.message);
}

class PrefsState {
  final bool showWebView;

  const PrefsState(this.showWebView);
}

class PrefsBloc {
  final _currentPrefs = BehaviorSubject<PrefsState>(
    seedValue: PrefsState(true),
  );

  final _showWebViewPref = StreamController<bool>();

  PrefsBloc() {
    _loadSharedPrefs();
    _showWebViewPref.stream.listen((bool) {
      _saveNewPrefs(PrefsState(bool));
    });
  }

  Stream<PrefsState> get currentPrefs => _currentPrefs.stream;

  Sink<bool> get showWebViewPref => _showWebViewPref.sink;

  void close() {
    _showWebViewPref.close();
    _currentPrefs.close();
  }

  Future<void> _loadSharedPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var showWebView = sharedPrefs.getBool('showWebView') ?? false;
    _currentPrefs.add(PrefsState(showWebView));
  }

  Future<void> _saveNewPrefs(PrefsState newState) async {
    var sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool('showWebView', newState.showWebView);
    _currentPrefs.add(newState);
  }
}
