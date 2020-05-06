import 'package:flutter/material.dart';
import 'package:hn_app/src/widgets/headline.dart';
import 'package:test/test.dart';

void main() {
  group('_GhostFadeTween', () {
    test('interpolates colors correctly', () {
      Color blue = Color.fromARGB(255, 0, 0, 255);
      Color red = Color.fromARGB(255, 255, 0, 0);
      Color white = Color.fromARGB(255, 255, 255, 255);
      GhostFadeTween tween = GhostFadeTween(
        begin: blue,
        end: red,
      );

      expect(tween.lerp(0.0), blue);
      expect(tween.lerp(0.5), white);
      expect(tween.lerp(1.0), red);
    });
  });
}
