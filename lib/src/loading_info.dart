import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoadingInfo extends StatefulWidget {
  final Stream<bool> _isLoading;

  LoadingInfo(this._isLoading);

  createState() => LoadingInfoState();
}

class LoadingInfoState extends State<LoadingInfo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget._isLoading,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          _controller.forward().then((_) {
            _controller.reverse();
          });
          return FadeTransition(
            child: Icon(FontAwesomeIcons.hackerNewsSquare),
            opacity: Tween(begin: .5, end: 1.0).animate(
                CurvedAnimation(curve: Curves.easeIn, parent: _controller)),
          );
        });
  }
}