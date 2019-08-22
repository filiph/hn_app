import 'package:hn_app/src/notifiers/hn_api.dart';
import 'package:test/test.dart';

void main() {
  test("worker fetches list of ids", () async {
    final worker = Worker();
    await worker.isReady;
    expect(worker.fetchIds("hello"), completion([1, 2, 3]));
    worker.dispose();
  });
}
