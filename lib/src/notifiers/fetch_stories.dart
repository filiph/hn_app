import 'dart:async';
import 'dart:io';

import 'package:built_value/serializer.dart';
import 'package:executorservices/executorservices.dart';
import 'package:hn_app/src/article.dart';
import 'package:hn_app/src/notifiers/hn_api.dart';
import 'package:http/http.dart' as http;

class FetchStories extends Task<List<Article>> {
  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0/';

  /// [_httpClient] can be passed, which allow us to switch the client in tests.
  FetchStories(
    StoriesType type, {
    http.Client networkClient,
    Map<int, Article> cachedArticles,
  })  : _url = _getIdsFullUrl(type),
        _httpClient = networkClient ?? http.Client(),
        _cachedArticles = cachedArticles;

  final String _url;

  final http.Client _httpClient;

  final Map<int, Article> _cachedArticles;

  @override
  FutureOr<List<Article>> execute() async {
    final articleIds = await _getIds(_url);

    final articles = await _getArticles(articleIds);

    return articles;
  }

  Future<List<Article>> _getArticles(List<int> articleIds) async {
    final results = <Article>[];

    // We are running the fetch of each article in parallel with Future.wait.
    // Here, we catch HackerNewsApiExceptions so that one API exception
    // doesn't stop the whole fetch.
    var futureArticles = articleIds.map<Future<void>>((id) async {
      try {
        var article = await _getArticle(id);
        results.add(article);
      } on HackerNewsApiException catch (e) {
        print(e);
      }
    });
    await Future.wait(futureArticles);
    var filtered = results.where((a) => a.title != null).toList();
    // Re-sort the articles according to the original order in [articleIds].
    // We need to do this because fetching the articles in parallel will
    // result in scrambled order.
    filtered.sort(
        (a, b) => articleIds.indexOf(a.id).compareTo(articleIds.indexOf(b.id)));
    return filtered;
  }

  Future<Article> _getArticle(int id) async {
    if (!_cachedArticles.containsKey(id)) {
      var storyUrl = '${_baseUrl}item/$id.json';
      try {
        var storyRes = await _httpClient.get(storyUrl);
        if (storyRes.statusCode == 200 && storyRes.body != null) {
          return parseArticle(storyRes.body);
        } else {
          throw HackerNewsApiException(statusCode: storyRes.statusCode);
        }
      } on DeserializationError {
        throw HackerNewsApiException(
          statusCode: 200,
          message: "Article was not parseable.",
        );
      } on http.ClientException {
        throw HackerNewsApiException(message: "Connection failed.");
      }
    }

    print("Founded article with id $id in the catch");

    return _cachedArticles[id];
  }

  Future<List<int>> _getIds(String url) async {
    http.Response response;
    try {
      response = await _httpClient.get(url);
    } on SocketException catch (e) {
      throw HackerNewsApiError("$url couldn't be fetched: $e");
    }
    if (response.statusCode != 200) {
      throw HackerNewsApiError("$url returned non-HTTP200");
    }

    var result = parseStoryIds(response.body);

    return result.take(10).toList();
  }

  static String _getIdsFullUrl(StoriesType type) {
    return '$_baseUrl${type == StoriesType.topStories ? 'top' : 'new'}stories.json';
  }
}
