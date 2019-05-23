import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:hn_app/src/article.dart';
import 'package:http/http.dart' as http;

class HackerNewsApiError extends Error {
  final String message;

  HackerNewsApiError(this.message);
}

class HackerNewsNotifier with ChangeNotifier {
  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0/';
  Map<int, Article> _cachedArticles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Article> _topArticles = [];
  UnmodifiableListView<Article> get topArticles =>
      UnmodifiableListView(_topArticles);

  List<Article> _newArticles = [];
  UnmodifiableListView<Article> get newArticles =>
      UnmodifiableListView(_newArticles);

  List<Article> _articles = [];
  UnmodifiableListView<Article> get articles => UnmodifiableListView(_articles);

  StoriesType _storiesType;
  StoriesType get storiesType => _storiesType;

  HackerNewsNotifier() : _cachedArticles = Map() {
    getStoriesByType(StoriesType.topStories);
  }

  Future<void> getStoriesByType(StoriesType type) async {
    _isLoading = true;
    notifyListeners();

    final ids = await _getIds(type);
    _articles = await _updateArticles(ids);

    switch (type) {
      case StoriesType.topStories:
        _topArticles = _articles;
        break;
      case StoriesType.newStories:
        _newArticles = _articles;
        break;
    }

    _isLoading = false;
    notifyListeners();
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
