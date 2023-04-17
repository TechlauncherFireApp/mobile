import 'package:fireapp/base/list_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListExtensions', () {
    test('has returns true if the list contains an element that satisfies the given test', () {
      final list = [1, 2, 3, 4, 5];
      expect(list.has((e) => e > 3), isTrue);
      expect(list.has((e) => e < 1), isFalse);
    });

    test('firstOrNull returns the first element that satisfies the given test, or null if none do', () {
      final list = [1, 2, 3, 4, 5];
      expect(list.firstOrNull((e) => e > 3), equals(4));
      expect(list.firstOrNull((e) => e < 1), isNull);
    });
  });
}
