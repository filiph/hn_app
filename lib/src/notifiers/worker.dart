import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:built_value/serializer.dart';
import 'package:hn_app/src/article.dart';
import 'package:hn_app/src/notifiers/hn_api.dart';
import 'package:http/http.dart' as http;

class Worker {
  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0/';

  SendPort _sendPort;

  Isolate _isolate;

  Completer<List<Article>> _ids;

  final _isolateReady = Completer<void>();

  Worker() {
    init();
  }

  Future<void> get isReady => _isolateReady.future;

  void dispose() {
    _isolate.kill();
  }

  Future<List<Article>> fetch(StoriesType type) async {
    var partUrl = type == StoriesType.topStories ? 'top' : 'new';
    var url = '$_baseUrl${partUrl}stories.json';

    _sendPort.send(url);

    // TODO: deal with multiple simultaneous requests
    _ids = Completer<List<Article>>();
    return _ids.future;
  }

  Future<void> init() async {
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    errorPort.listen(print);

    receivePort.listen(_handleMessage);
    _isolate = await Isolate.spawn(
      _isolateEntry,
      receivePort.sendPort,
      onError: errorPort.sendPort,
    );
  }

  void _handleMessage(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
      return;
    }

    if (message is List<Article>) {
      _ids?.complete(message);
      _ids = null;
      return;
    }

    throw UnimplementedError("Undefined behavior for message: $message");
  }

  static Future<Article> _getArticle(http.Client client, int id) async {
    var storyUrl = '${_baseUrl}item/$id.json';
    try {
      var storyRes = await client.get(storyUrl);
      if (storyRes.statusCode == 200 && storyRes.body != null) {
        return parseArticle(storyRes.body);
      } else {
        throw HackerNewsApiException(statusCode: storyRes.statusCode);
      }
    } on DeserializationError {
      throw HackerNewsApiException(
          statusCode: 200, message: "Article was not parseable.");
    } on http.ClientException {
      throw HackerNewsApiException(message: "Connection failed.");
    }
  }

  static Future<List<Article>> _getArticles(
      http.Client client, List<int> articleIds) async {
    final results = <Article>[];

    // We are running the fetch of each article in parallel with Future.wait.
    // Here, we catch HackerNewsApiExceptions so that one API exception
    // doesn't stop the whole fetch.
    var futureArticles = articleIds.map<Future<void>>((id) async {
      try {
        var article = await _getArticle(client, id);
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

  static Future<List<int>> _getIds(http.Client client, String url) async {
    http.Response response;
    try {
      response = await client.get(url);
    } on SocketException catch (e) {
      throw HackerNewsApiException(message: "$url couldn't be fetched: $e");
    }
    if (response.statusCode != 200) {
      throw HackerNewsApiException(message: "$url returned non-HTTP200");
    }

    var result = parseStoryIds(response.body);

    return result.take(10).toList();
  }

  static void _isolateEntry(dynamic message) {
    SendPort sendPort;
    final receivePort = ReceivePort();

    receivePort.listen((dynamic message) async {
      assert(message is String);
      final client = http.Client();
      try {
        final ids = await _getIds(client, message);
        final articles = await _getArticles(client, ids);
        sendPort.send(articles);
      } finally {
        client.close();
      }
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }
}
