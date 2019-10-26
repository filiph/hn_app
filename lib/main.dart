import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hn_app/src/article.dart';
import 'package:hn_app/src/favorites.dart';
import 'package:hn_app/src/notifiers/hn_api.dart';
import 'package:hn_app/src/notifiers/prefs.dart';
import 'package:hn_app/src/pages/favorites.dart';
import 'package:hn_app/src/pages/settings.dart';
import 'package:hn_app/src/widgets/headline.dart';
import 'package:hn_app/src/widgets/loading_info.dart';
import 'package:hn_app/src/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<LoadingTabsCount>(
          builder: (_) => LoadingTabsCount(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<MyDatabase>(builder: (_) => MyDatabase()),
        ChangeNotifierProvider(
          builder: (context) => HackerNewsNotifier(
            // TODO(filiph): revisit when ProxyProvider lands
            // https://github.com/rrousselGit/provider/issues/46
            Provider.of<LoadingTabsCount>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(builder: (_) => PrefsNotifier()),
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
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
          brightness: Provider.of<PrefsNotifier>(context).userDarkMode
              ? Brightness.dark
              : Brightness.light,
          canvasColor: Theme.of(context).brightness == Brightness.dark ||
                  Provider.of<PrefsNotifier>(context).userDarkMode
              ? Colors.black
              : Colors.white,
          primaryColor: primaryColor,
          scaffoldBackgroundColor: primaryColor,
          textTheme: Theme.of(context).textTheme.copyWith(
              caption: TextStyle(color: Colors.white54),
              subhead: TextStyle(fontFamily: 'Garamond', fontSize: 10.0))),
      routes: {
        '/': (context) => MyHomePage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// The Key of the nested Navigator in the body of [_MyHomePageState].
///
/// It's a GlobalKey because we need to access it from the drawer (which is
/// outside the body).
GlobalKey<NavigatorState> _pageNavigatorKey = GlobalKey<NavigatorState>();

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    _pageController.addListener(_handlePageChange);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    super.dispose();
  }

  void _handlePageChange() {
    setState(() {
      _currentIndex = _pageController.page.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hn = Provider.of<HackerNewsNotifier>(context);
    final tabs = hn.tabs;
    final current = tabs[_currentIndex];

    if (current.articles.isEmpty && !current.isLoading) {
      // New tab with no data. Let's fetch some.
      Future(() => current.refresh());
    }

    return Scaffold(
      appBar: AppBar(
        title: Headline(
          text: tabs[_currentIndex].name,
          index: _currentIndex,
        ),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              var result = await showSearch(
                context: context,
                delegate: ArticleSearch(hn.allArticles),
              );
              if (result != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HackerNewsWebPage(result.url)));
              }
            },
          ),
        ],
        leading: Consumer<LoadingTabsCount>(builder: (context, loading, child) {
          bool isLoading = loading.value > 0;
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: isLoading
                // TODO: make sure that LoadingInfo is rotating when shown
                //       or, better, collapse the two alternate widgets into one
                ? LoadingInfo(loading)
                : IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
          );
        }),
      ),
      // A nested navigator so we can push routes in the body from the drawer.
      body: Navigator(
        key: _pageNavigatorKey,
        onGenerateRoute: (settings) {
          // TODO: use PageRouteBuilders below instead of MaterialPageRoute
          //       and merely cross-fade the routes

          if (settings.name == '/favorites') {
            return MaterialPageRoute(
              builder: (context) => FavoritesPage(),
            );
          }

          return MaterialPageRoute(
            builder: (context) => PageView.builder(
              controller: _pageController,
              itemCount: tabs.length,
              itemBuilder: (context, index) => ChangeNotifierProvider.value(
                notifier: tabs[index],
                child: _TabPage(index),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(
              title: Text(tab.name),
              icon: Icon(tab.icon),
            )
        ],
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic);
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text('HN APP'),
              ),
              ListTile(
                title: Text('Favorites'),
                onTap: () {
                  _pageNavigatorKey.currentState
                      .pushReplacementNamed('/favorites');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Settings'),
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Article article;
  final PrefsNotifier prefs;

  const _Item({
    Key key,
    @required this.article,
    @required this.prefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PrefsNotifier>(context);
    var myDatabase = Provider.of<MyDatabase>(context);
    assert(article.title != null);
    return Padding(
      key: PageStorageKey(article.title),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Column(
        children: <Widget>[
          ExpansionTile(
            leading: StreamBuilder<bool>(
                stream: myDatabase.isFavorite(article.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data) {
                    return IconButton(
                        icon: Icon(Icons.star),
                        onPressed: () => myDatabase.removeFavorite(article.id));
                  }
                  return IconButton(
                      icon: Icon(Icons.star_border),
                      onPressed: () => myDatabase.addFavorite(article));
                }),
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
                    prefs.showWebView
                        ? Container(
                            height: 200,
                            child: WebView(
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl: article.url,
                              gestureRecognizers: Set()
                                ..add(Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer())),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabPage extends StatelessWidget {
  final int index;

  _TabPage(this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<HackerNewsTab>(context);
    final articles = tab.articles;
    final prefs = Provider.of<PrefsNotifier>(context);

    if (tab.isLoading && articles.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.black,
      onRefresh: () => tab.refresh(),
      child: ListView(
        key: PageStorageKey(index),
        children: [
          for (final article in articles)
            _Item(
              article: article,
              prefs: prefs,
            )
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
        javascriptMode: JavascriptMode.unrestricted,
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
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
