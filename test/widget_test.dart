// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.
// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hn_app/main.dart';
// import 'package:hn_app/src/widgets/headline.dart';

void main() {
  testWidgets('clicking tile opens it', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    expect(find.byIcon(Icons.launch), findsNothing);

    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pump();

    expect(find.byIcon(Icons.launch), findsOneWidget);
  }, skip: true);

  // testWidgets('headline animates and changes text correctly',
  //     (WidgetTester tester) async {
  //   final controller = StreamController<String>();
  //   Stream<String> headlineStream = controller.stream;

  //   Widget widget = StatefulBuilder(
  //     builder: (BuildContext context, snapshot) {
  //       print(snapshot.data);
  //       if (!snapshot.hasData) {
  //         return Container();
  //       }
  //       return Directionality(
  //         textDirection: TextDirection.ltr,
  //         child: Headline(
  //           text: snapshot.data,
  //           index: 0,
  //         ),
  //       );
  //     },
  //   );
  //   await tester.pumpWidget(
  //     widget,
  //   );

  //   controller.add('Foo');

  //   await tester.pump();

  //   await expectLater(find.text('Foo'), findsOneWidget);

  //   controller.add('Bar');

  //   controller.close();
  // });
}
