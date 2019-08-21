import 'package:hn_app/src/article.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'favorites.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class Favorites extends Table {
  // article id
  IntColumn get id => integer().customConstraint('UNIQUE')();
  TextColumn get title => text()();
  TextColumn get url => text()();
  TextColumn get category => text().nullable()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [Favorites])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db1.sqlite'));

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  Future<List<Favorite>> get allFavorites => select(favorites).get();

  void addFavorite(Article article) {
    var favorite = Favorite(
        id: article.id,
        url: article.url,
        title: article.title,
        category: article.type);
    into(favorites).insert(favorite);
  }

  void removeFavorite(int i) =>
      (delete(favorites)..where((t) => t.id.equals(i))).go();

  // watches all todo entries in a given category. The stream will automatically
  // emit new items whenever the underlying data changes.
  Stream<bool> isFavorite(int id) {
    // TODO: is there a count for Moor ? MOAR APIS?!
    // https://github.com/simolus3/moor/issues/55#issuecomment-507808555
    return select(favorites).watch().map(
        (favoritesList) => favoritesList.any((favorite) => favorite.id == id));
    // return (select(favorites)..where((favorite) => favorite.id.equals(id)))
    //    .watch()
    //    .map((favoritesList) => favoritesList.length >= 1);
  }
}
