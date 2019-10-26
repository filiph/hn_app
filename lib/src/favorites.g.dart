// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class Favorite extends DataClass {
  final int id;
  final String title;
  final String url;
  final String category;
  Favorite({this.id, this.title, this.url, this.category});
  factory Favorite.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Favorite(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      url: stringType.mapFromDatabaseResponse(data['${effectivePrefix}url']),
      category: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}category']),
    );
  }
  factory Favorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      url: serializer.fromJson<String>(json['url']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'url': serializer.toJson<String>(url),
      'category': serializer.toJson<String>(category),
    };
  }

  Favorite copyWith({int id, String title, String url, String category}) =>
      Favorite(
        id: id ?? this.id,
        title: title ?? this.title,
        url: url ?? this.url,
        category: category ?? this.category,
      );
  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc($mrjc($mrjc(0, id.hashCode), title.hashCode), url.hashCode),
      category.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == id &&
          other.title == title &&
          other.url == url &&
          other.category == category);
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  final GeneratedDatabase _db;
  final String _alias;
  $FavoritesTable(this._db, [this._alias]);
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE');
  }

  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _url;
  @override
  GeneratedTextColumn get url => _url ??= _constructUrl();
  GeneratedTextColumn _constructUrl() {
    return GeneratedTextColumn(
      'url',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _category;
  @override
  GeneratedTextColumn get category => _category ??= _constructCategory();
  GeneratedTextColumn _constructCategory() {
    return GeneratedTextColumn(
      'category',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, title, url, category];
  @override
  $FavoritesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'favorites';
  @override
  final String actualTableName = 'favorites';
  @override
  bool validateIntegrity(Favorite instance, bool isInserting) =>
      id.isAcceptableValue(instance.id, isInserting) &&
      title.isAcceptableValue(instance.title, isInserting) &&
      url.isAcceptableValue(instance.url, isInserting) &&
      category.isAcceptableValue(instance.category, isInserting);
  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Favorite map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Favorite.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(Favorite d, {bool includeNulls = false}) {
    final map = <String, Variable>{};
    if (d.id != null || includeNulls) {
      map['id'] = Variable<int, IntType>(d.id);
    }
    if (d.title != null || includeNulls) {
      map['title'] = Variable<String, StringType>(d.title);
    }
    if (d.url != null || includeNulls) {
      map['url'] = Variable<String, StringType>(d.url);
    }
    if (d.category != null || includeNulls) {
      map['category'] = Variable<String, StringType>(d.category);
    }
    return map;
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.withDefaults(), e);
  $FavoritesTable _favorites;
  $FavoritesTable get favorites => _favorites ??= $FavoritesTable(this);
  @override
  List<TableInfo> get allTables => [favorites];
}
