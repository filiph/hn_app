import 'package:flutter/material.dart';
import 'package:hn_app/src/favorites.dart';
import 'package:provider/provider.dart';
import 'package:hn_app/src/widgets/hn_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<Favorite> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = [];
  }

  @override
  Widget build(BuildContext context) {
    var myDatabase = Provider.of<MyDatabase>(context);

    // TODO: add comments to the favorites page.
    return Scaffold(
      appBar: AppBar(
        title: Text("FAVORITES"),
      ),
      body: StreamBuilder(
        stream: myDatabase.allFavorites.asStream(),
        builder: (context, AsyncSnapshot<List<Favorite>> snapshot) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (_, index) {
                    if (snapshot.data == null) {
                      return Container();
                    }
                    Favorite article = snapshot.data![index];

                    return ListTile(
                      leading: IconButton(
                          icon: Icon(Icons.star),
                          onPressed: () {
                            myDatabase.removeFavorite(article.id);
                            // TODO(fitza): verify that this is or isn't best practice
                            setState(() => {});
                          }),
                      title: Text(snapshot.data![index].title),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HackerNewsWebPage(article.url)));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
