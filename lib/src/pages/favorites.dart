import 'package:flutter/material.dart';
import 'package:hn_app/src/favorites.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Favorite> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = [];
  }

  @override
  Widget build(BuildContext context) {
    var myDatabase = Provider.of<MyDatabase>(context);

    // TODO: allow going back to Top Stories and New Stories.

    // TODO: Make favorites ack like top and new stories.
    return StreamBuilder(
      stream: myDatabase.allFavorites.asStream(),
      builder: (context, AsyncSnapshot<List<Favorite>> snapshot) {
        return Column(
          children: <Widget>[
            Center(child: Text("FAVORITES")),
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    //TODO(fitza): Make this tappable to remove the favorite
                    leading: Icon(Icons.star),
                    title: Text(snapshot.data[index].title),
                    onTap: () {
                      //TODO(fitza): Load the actual article itself.
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );

    // return Column(
    //   children: <Widget>[
    //     Center(child: Text("FAVORITES")),
    //     Expanded(
    //         child: ListView.builder(
    //             itemCount: _favorites.length,
    //             itemBuilder: (_, index) {
    //               return ListTile(title: Text(_favorites[index].title));
    //             })),
    //   ],
    // );
  }
}
