import 'package:hn_app/src/notifiers/worker.dart';
import 'package:test/test.dart';

void main() {
  test("worker spins up", () async {
    final worker = Worker();
    await worker.isReady;
    worker.dispose();
  });
}
