import 'dart:convert' as json;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'article.g.dart';

/// Note: If changing this file, see readme for how to regenerate
/// serialization code.
abstract class Article implements Built<Article, ArticleBuilder> {
  static Serializer<Article> get serializer => _$articleSerializer;

  int get id;

  bool? get deleted;

  /// This is the type of the article.
  ///
  /// It can be any of these: "job", "story", "comment", "poll", or "pollopt".
  String get type;

  String get by;

  int get time;

  String? get text;

  bool? get dead;

  int? get parent;

  int? get poll;

  BuiltList<int>? get kids;

  String? get url;

  int? get score;

  String? get title;

  BuiltList<int>? get parts;

  int? get descendants;

  Article._();

  factory Article([updates(ArticleBuilder b)?]) = _$Article;
}

List<int> parseStoryIds(String jsonStr) {
  var parsed = json.jsonDecode(jsonStr);
  var listOfIds = List<int>.from(parsed);
  return listOfIds;
}

Article parseArticle(String jsonStr) {
  var parsed = json.jsonDecode(jsonStr);
  var article = standardSerializers.deserializeWith(Article.serializer, parsed);

  if (article == null) {
    // TODO(fitza) choose a better exception and message
    throw StateError("null article");
  }
  return article;
}
