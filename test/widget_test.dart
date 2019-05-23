// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.
// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hn_app/src/widgets/headline.dart';

void main() {
  testWidgets('headline animates and changes text correctly',
      (WidgetTester tester) async {
    String text = "Foo";
    int index = 0;
    Key buttonKey = GlobalKey();
    Key headlineKey = GlobalKey();

    Widget widget = StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: <Widget>[
              Headline(
                key: headlineKey,
                text: text,
                index: index,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    text = 'Bar';
                    index = 1;
                  });
                },
                child: Text("Tap"),
                key: buttonKey,
              )
            ],
          ),
        );
      },
    );
    await tester.pumpWidget(
      widget,
    );

    expect(find.text('Foo'), findsOneWidget);

    await tester.pump();

    await tester.tap(find.byKey(buttonKey));

    await tester.pumpAndSettle();

    expect(find.text('Bar'), findsOneWidget);
  });

  testWidgets('headline animates and changes text color correctly',
      (WidgetTester tester) async {
    String text = "Foo";
    int index = 0;
    Key buttonKey = GlobalKey();
    Key headlineKey = GlobalKey();
    Headline headline;

    Widget widget = StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        headline = Headline(
          key: headlineKey,
          text: text,
          index: index,
        );

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: <Widget>[
              headline,
              FlatButton(
                onPressed: () {
                  setState(() {
                    text = 'Bar';
                    index = 1;
                  });
                },
                child: Text("Tap"),
                key: buttonKey,
              )
            ],
          ),
        );
      },
    );
    await tester.pumpWidget(
      widget,
    );

    expect(headline.targetColor, headlineTextColors[index]);

    await tester.pump();

    await tester.tap(find.byKey(buttonKey));

    await tester.pumpAndSettle();

    expect(headline.targetColor, headlineTextColors[index]);
  });
}
