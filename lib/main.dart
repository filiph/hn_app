import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hn_app/src/article.dart';
import 'package:hn_app/src/hn_bloc.dart';
import 'package:hn_app/src/loading_info.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  final hnBloc = HackerNewsBloc();
  runApp(MyApp(bloc: hnBloc));
}

class MyApp extends StatelessWidget {
  final HackerNewsBloc bloc;

  MyApp({
    Key key,
    this.bloc,
  }) : super(key: key);

  static const primaryColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: primaryColor,
          canvasColor: Colors.black,
          textTheme: Theme.of(context).textTheme.copyWith(
              caption: TextStyle(color: Colors.white54),
              subhead: TextStyle(fontFamily: 'Garamond', fontSize: 10.0))),
      home: MyHomePage(
        title: 'Flutter Hacker News',
        bloc: bloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HackerNewsBloc bloc;

  final String title;

  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: LoadingInfo(widget.bloc.isLoading),
        elevation: 0.0,
        actions: [
          Builder(
            builder: (context) => IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final Article result = await showSearch(
                      context: context,
                      delegate: ArticleSearch(widget.bloc.articles),
                    );
                    if (result != null && await canLaunch(result.url)) {
                      launch(result.url);
                    }
                  },
                ),
          ),
        ],
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: widget.bloc.articles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (context, snapshot) => ListView(
              children: snapshot.data.map(_buildItem).toList(),
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            title: Text('Top Stories'),
            icon: Icon(Icons.arrow_drop_up),
          ),
          BottomNavigationBarItem(
            title: Text('New Stories'),
            icon: Icon(Icons.new_releases),
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            widget.bloc.storiesType.add(StoriesType.topStories);
          } else {
            widget.bloc.storiesType.add(StoriesType.newStories);
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.title),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: ExpansionTile(
        title:
            Text(article.title ?? '[null]', style: TextStyle(fontSize: 24.0)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('${article.descendants} comments'),
                SizedBox(width: 16.0),
                IconButton(
                  icon: Icon(Icons.launch),
                  onPressed: () async {
                    if (await canLaunch(article.url)) {
                      launch(article.url);
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleSearch extends SearchDelegate<Article> {
  final Stream<UnmodifiableListView<Article>> articles;

  ArticleSearch(this.articles);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<Article>>(
      stream: articles,
      builder:
          (context, AsyncSnapshot<UnmodifiableListView<Article>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Text(
            'No data!',
          ));
        }

        final results = snapshot.data
            .where((a) => a.title.toLowerCase().contains(query.toLowerCase()));

        return ListView(
          children: results
              .map<ListTile>((a) => ListTile(
                    title: Text(a.title,
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(fontSize: 16.0)),
                    leading: Icon(Icons.book),
                    onTap: () async {
                      if (await canLaunch(a.url)) {
                        await launch(a.url);
                      }
                      close(context, a);
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<Article>>(
      stream: articles,
      builder:
          (context, AsyncSnapshot<UnmodifiableListView<Article>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Text(
            'No data!',
          ));
        }

        final results = snapshot.data
            .where((a) => a.title.toLowerCase().contains(query.toLowerCase()));

        return ListView(
          children: results
              .map<ListTile>((a) => ListTile(
                    title: Text(a.title,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                              fontSize: 16.0,
                              color: Colors.blue,
                            )),
                    onTap: () {
                      close(context, a);
                    },
                  ))
              .toList(),
        );
      },
    );
  }
}
