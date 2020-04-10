import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hn_app/src/article.dart';
import 'package:hn_app/src/notifiers/worker.dart';
import 'package:logging/logging.dart';

class HackerNewsApiError extends Error {
  final String message;

  HackerNewsApiError(this.message);
}

/// The number of tabs that are currently loading.
class LoadingTabsCount extends ValueNotifier<int> {
  LoadingTabsCount() : super(0);
}

/// This class encapsulates the app's communication with the Hacker News API
/// and which articles are fetched in which [tabs].
class HackerNewsNotifier with ChangeNotifier {
  static final _log = Logger('HackerNewsNotifier');

  List<HackerNewsTab> _tabs;

  HackerNewsNotifier(LoadingTabsCount loading) {
    _log.fine('constructor called');

    _tabs = [
      HackerNewsTab(
        StoriesType.topStories,
        'Top Stories',
        Icons.arrow_drop_up,
        loading,
      ),
      HackerNewsTab(
        StoriesType.newStories,
        'New Stories',
        Icons.new_releases,
        loading,
      ),
    ];

    scheduleMicrotask(() {
      _log.fine('First refresh of first tab called');
      _tabs.first.refresh();
    });
  }

  /// Articles from all tabs. De-duplicated.
  UnmodifiableListView<Article> get allArticles => UnmodifiableListView(
      _tabs.expand((tab) => tab.articles).toSet().toList(growable: false));

  UnmodifiableListView<HackerNewsTab> get tabs => UnmodifiableListView(_tabs);
}

class HackerNewsTab with ChangeNotifier {
  final Logger _log;

  final StoriesType storiesType;

  final String name;

  List<Article> _articles = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final IconData icon;

  final LoadingTabsCount loadingTabsCount;

  HackerNewsTab(this.storiesType, this.name, this.icon, this.loadingTabsCount)
      // In this case, we want the logger name to have the type of the stories
      // in it. So we make it an instance field, and initialize it here.
      : _log = Logger('HackerNewsTab.$storiesType');

  UnmodifiableListView<Article> get articles => UnmodifiableListView(_articles);

  Future<void> refresh() async {
    _log.info('refresh() called');
    _isLoading = true;
    notifyListeners();
    loadingTabsCount.value += 1;

    final worker = Worker();
    await worker.isReady;
    _log.fine('worker created and ready, fetching');

    _articles = await worker.fetch(storiesType);
    _isLoading = false;
    _log.fine('articles fetched');

    worker.dispose();

    // TODO: remove the artificial delay, or don't wait if the actual fetch
    //       has taken enough time
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
    loadingTabsCount.value -= 1;
    _log.fine('articles refreshed, listeners notified');
  }
}

enum StoriesType {
  topStories,
  newStories,
}

class HackerNewsApiException implements Exception {
  final int statusCode;
  final String message;

  const HackerNewsApiException({this.statusCode, this.message});
}
