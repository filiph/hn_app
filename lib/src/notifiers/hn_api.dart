import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hn_app/src/article.dart';
import 'package:http/http.dart' as http;

/// A global cache of articles.
Map<int, Article> _cachedArticles = {};

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
  List<HackerNewsTab> _tabs;

  HackerNewsNotifier(LoadingTabsCount loading) {
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

    scheduleMicrotask(() => _tabs.first.refresh());
  }

  /// Articles from all tabs. De-duplicated.
  UnmodifiableListView<Article> get allArticles => UnmodifiableListView(
      _tabs.expand((tab) => tab.articles).toSet().toList(growable: false));

  UnmodifiableListView<HackerNewsTab> get tabs => UnmodifiableListView(_tabs);
}

class HackerNewsTab with ChangeNotifier {
  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0/';

  final StoriesType storiesType;

  final String name;

  List<Article> _articles = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final IconData icon;

  final LoadingTabsCount loadingTabsCount;

  HackerNewsTab(this.storiesType, this.name, this.icon, this.loadingTabsCount);

  UnmodifiableListView<Article> get articles => UnmodifiableListView(_articles);

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    loadingTabsCount.value += 1;

    final ids = await _getIds(storiesType);
    _articles = await _updateArticles(ids);
    _isLoading = false;
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
    loadingTabsCount.value -= 1;
  }

  Future<Article> _getArticle(int id) async {
    if (!_cachedArticles.containsKey(id)) {
      var storyUrl = '${_baseUrl}item/$id.json';
      var storyRes = await http.get(storyUrl);
      if (storyRes.statusCode == 200 && storyRes.body != null) {
        try {
          _cachedArticles[id] = parseArticle(storyRes.body);
        } catch (e) {
          print(e.runtimeType);
          rethrow;
        }
      } else {
        throw HackerNewsApiException(storyRes.statusCode);
      }
    }
    return _cachedArticles[id];
  }

  Future<List<int>> _getIds(StoriesType type) async {
    var partUrl = type == StoriesType.topStories ? 'top' : 'new';
    var url = '$_baseUrl${partUrl}stories.json';
    var error =
        () => throw HackerNewsApiError("Stories $type couldn't be fetched.");

    var response;
    try {
      response = await http.get(url);
    } on SocketException {
      error();
    }
    if (response.statusCode != 200) {
      error();
    }

    var result = parseStoryIds(response.body);

    return result.take(10).toList();
  }

  Future<List<Article>> _updateArticles(List<int> articleIds) async {
    var futureArticles = articleIds
        .map((id) => _getArticle(id))
        .where((article) => article != null);
    var all = await Future.wait(futureArticles);
    var filtered = all.where((a) => a.title != null).toList();
    return filtered;
  }
}

enum StoriesType {
  topStories,
  newStories,
}

class HackerNewsApiException implements Exception {
  final int statusCode;
  final int message;

  const HackerNewsApiException(this.statusCode, [this.message]);
}

class Worker {
  SendPort _sendPort;

  Isolate _isolate;

  Completer<List<int>> _ids;

  final _isolateReady = Completer<void>();

  Worker() {
    init();
  }

  Future<List<int>> fetchIds(String url) {
    _sendPort.send(url);
    _ids = Completer<List<int>>();
    return _ids.future;
  }

  Future<void> init() async {
    final receivePort = ReceivePort();

    receivePort.listen(_handleMessage);
    _isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);
  }

  Future<void> get isReady => _isolateReady.future;

  void dispose() {
    _isolate.kill();
  }

  static void _isolateEntry(dynamic message) {
    SendPort sendPort;
    final receivePort = ReceivePort();

    receivePort.listen((dynamic message) {
      assert(message is String);
      sendPort.send([1, 2, 3]);
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }

  void _handleMessage(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
      return;
    }

    if (message is List<int>) {
      _ids?.complete(message);
      _ids = null;
      return;
    }
  }
}
