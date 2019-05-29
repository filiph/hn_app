import 'dart:async';
import 'dart:collection';

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
    notifyListeners();
    loadingTabsCount.value -= 1;
  }

  Future<Article> _getArticle(int id) async {
    if (!_cachedArticles.containsKey(id)) {
      var storyUrl = '${_baseUrl}item/$id.json';
      var storyRes = await http.get(storyUrl);
      if (storyRes.statusCode == 200) {
        _cachedArticles[id] = parseArticle(storyRes.body);
      } else {
        throw HackerNewsApiError("Article $id couldn't be fetched.");
      }
    }
    return _cachedArticles[id];
  }

  Future<List<int>> _getIds(StoriesType type) async {
    var partUrl = type == StoriesType.topStories ? 'top' : 'new';
    var url = '$_baseUrl${partUrl}stories.json';
    var response = await http.get(url);
    if (response.statusCode != 200) {
      throw HackerNewsApiError("Stories $type couldn't be fetched.");
    }
    return parseTopStories(response.body).take(10).toList();
  }

  Future<List<Article>> _updateArticles(List<int> articleIds) async {
    var futureArticles = articleIds.map((id) => _getArticle(id));
    var all = await Future.wait(futureArticles);
    var filtered = all.where((a) => a.title != null).toList();
    return filtered;
  }
}

enum StoriesType {
  topStories,
  newStories,
}
