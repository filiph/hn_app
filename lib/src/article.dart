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

  @nullable
  bool get deleted;

  /// This is the type of the article.
  ///
  /// It can be any of these: "job", "story", "comment", "poll", or "pollopt".
  String get type;

  String get by;

  int get time;

  @nullable
  String get text;

  @nullable
  bool get dead;

  @nullable
  int get parent;

  @nullable
  int get poll;

  BuiltList<int> get kids;

  @nullable
  String get url;

  @nullable
  int get score;

  @nullable
  String get title;

  BuiltList<int> get parts;

  @nullable
  int get descendants;

  Article._();

  factory Article([updates(ArticleBuilder b)]) = _$Article;
}

List<int> parseStoryIds(String jsonStr) {
  var parsed = json.jsonDecode(jsonStr);
  var listOfIds = List<int>.from(parsed);
  return listOfIds;
}

Article parseArticle(String jsonStr) {
  var parsed = json.jsonDecode(jsonStr);
  var article = standardSerializers.deserializeWith(Article.serializer, parsed);
  return article;
}
