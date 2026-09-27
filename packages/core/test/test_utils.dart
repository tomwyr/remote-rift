import 'package:fake_async/fake_async.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

@isTest
void testAsync(String description, void Function(FakeAsync async) body) {
  test(description, () => fakeAsync(body));
}
