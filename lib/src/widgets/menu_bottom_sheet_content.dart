import 'package:flutter/material.dart';
import 'package:groovin_widgets/modal_drawer_handle.dart';

class MenuBottomSheetContent extends StatelessWidget {
  final GlobalKey<NavigatorState> pageNavigatorKey;

  const MenuBottomSheetContent({
    Key key,
    this.pageNavigatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ModalDrawerHandle(),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              'Favorites',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              pageNavigatorKey.currentState.pushReplacementNamed('/favorites');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
