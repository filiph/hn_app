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

  Completer<List<int>> _ids;

  final _isolateReady = Completer<void>();

  Worker() {
    init();
  }

  Future<List<Article>> fetch(StoriesType type) async {
    final ids = await _fetchIds(type);
    return _getArticles(ids);
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
    return filtered;
  }

  Future<Article> _getArticle(int id) async {
    var storyUrl = '${_baseUrl}item/$id.json';
    try {
      var storyRes = await http.get(storyUrl);
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

  Future<List<int>> _fetchIds(StoriesType type) {
    var partUrl = type == StoriesType.topStories ? 'top' : 'new';
    var url = '$_baseUrl${partUrl}stories.json';

    _sendPort.send(url);

    // TODO: deal with multiple simultaneous requests
    _ids = Completer<List<int>>();
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

  Future<void> get isReady => _isolateReady.future;

  void dispose() {
    _isolate.kill();
  }

  static void _isolateEntry(dynamic message) {
    SendPort sendPort;
    final receivePort = ReceivePort();

    receivePort.listen((dynamic message) async {
      assert(message is String);
      final ids = await _getIds(message);
      sendPort.send(ids);
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }

  static Future<List<int>> _getIds(String url) async {
    http.Response response;
    try {
      response = await http.get(url);
    } on SocketException catch (e) {
      throw HackerNewsApiError("$url couldn't be fetched: $e");
    }
    if (response.statusCode != 200) {
      throw HackerNewsApiError("$url returned non-HTTP200");
    }

    var result = parseStoryIds(response.body);

    return result.take(10).toList();
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

    throw UnimplementedError("Undefined behavior for message: $message");
  }
}
