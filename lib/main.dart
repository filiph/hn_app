import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hn_app/src/article.dart';
import 'package:hn_app/src/hn_bloc.dart';
import 'package:hn_app/src/loading_info.dart';
import 'package:hn_app/src/prefs_bloc.dart';
import 'package:hn_app/src/widgets/headline.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ValueListenableProvider(builder: (_) => ValueNotifier(true)),
        ChangeNotifierProvider(builder: (_) => HackerNewsNotifier()),
        Provider(builder: (_) => PrefsBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline(
          text: _currentIndex == 0 ? 'Top Stories' : 'New Stories',
          index: _currentIndex,
        ),
        leading: LoadingInfo(),
        elevation: 0.0,
//        actions: [
//          IconButton(
//            icon: Icon(Icons.search),
//            onPressed: () async {
//              var result = await showSearch(
//                context: context,
//                delegate: ArticleSearch(_currentIndex == 0
//                    ? Provider.of<HackerNewsNotifier>(context).topArticles
//                    : Provider.of<HackerNewsNotifier>(context).newArticles),
//              );
//              if (result != null) {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => HackerNewsWebPage(result.url)));
//              }
//            },
//          ),
//        ],
      ),
      body: Consumer<HackerNewsNotifier>(
        builder: (context, bloc, child) => ListView(
              key: PageStorageKey(_currentIndex),
              children: bloc.articles
                  .map((a) => _Item(
                        article: a,
                        prefsBloc: Provider.of<PrefsBloc>(context),
                      ))
                  .toList(),
            ),
      ),
      floatingActionButton: Consumer<bool>(
        builder: (context, isLoading, child) => FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.shop,
                color: isLoading ? Colors.yellowAccent : Colors.green)),
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
            Provider.of<HackerNewsNotifier>(context)
                .getStoriesByType(StoriesType.topStories);
          } else {
            assert(index == 1);
            Provider.of<HackerNewsNotifier>(context)
                .getStoriesByType(StoriesType.newStories);
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Article article;
  final PrefsBloc prefsBloc;

  const _Item({
    Key key,
    @required this.article,
    @required this.prefsBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(article.title != null);
    return Padding(
      key: PageStorageKey(article.title),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: ExpansionTile(
        title: Text(article.title, style: TextStyle(fontSize: 24.0)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  HackerNewsCommentPage(article.id),
                            ),
                          ),
                      child: Text('${article.descendants} comments'),
                    ),
                    SizedBox(width: 16.0),
                    IconButton(
                      icon: Icon(Icons.launch),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HackerNewsWebPage(article.url))),
                    )
                  ],
                ),
                StreamBuilder<PrefsState>(
                  stream: prefsBloc.currentPrefs,
                  builder: (context, snapshot) {
                    if (snapshot.data?.showWebView == true) {
                      return Container(
                        height: 200,
                        child: WebView(
                          javaScriptMode: JavaScriptMode.unrestricted,
                          initialUrl: article.url,
                          gestureRecognizers: Set()
                            ..add(Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer())),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HackerNewsWebPage extends StatelessWidget {
  HackerNewsWebPage(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Page'),
      ),
      body: WebView(
        initialUrl: url,
        javaScriptMode: JavaScriptMode.unrestricted,
      ),
    );
  }
}

class HackerNewsCommentPage extends StatelessWidget {
  final int id;

  HackerNewsCommentPage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: WebView(
        initialUrl: 'https://news.ycombinator.com/item?id=$id',
        javaScriptMode: JavaScriptMode.unrestricted,
      ),
    );
  }
}
