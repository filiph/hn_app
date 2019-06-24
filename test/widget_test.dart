// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.
// import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hn_app/src/widgets/headline.dart';

void main() {
  testWidgets('headline animates and changes text correctly',
      (WidgetTester tester) async {
    final controller = StreamController<String>();

    Widget widget = StreamBuilder(
      stream: controller.stream,
      initialData: 'Foo',
      builder: (context, snapshot) => Directionality(
            textDirection: TextDirection.ltr,
            child: Headline(
              text: snapshot.data,
              index: 0,
            ),
          ),
    );

    await tester.pumpWidget(widget);

    expect(find.text('Foo'), findsOneWidget);

    controller.add('Bar');

    await tester.pumpAndSettle();

    expect(find.text('Bar'), findsOneWidget);

    controller.close();
  });

  testWidgets('headline animates and changes text color correctly',
      (WidgetTester tester) async {
    final controller = StreamController<int>();

    Headline headline;
    Widget widget = StreamBuilder(
      stream: controller.stream,
      initialData: 0,
      builder: (context, snapshot) {
        headline = Headline(
          text: 'Foo',
          index: snapshot.data,
        );
        return Directionality(
          textDirection: TextDirection.ltr,
          child: headline,
        );
      },
    );

    await tester.pumpWidget(widget);

    expect(headline.targetColor, headlineTextColors[0]);

    controller.add(1);

    await tester.pumpAndSettle();

    expect(headline.targetColor, headlineTextColors[1]);

    controller.close();
  });
}
