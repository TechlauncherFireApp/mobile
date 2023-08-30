
import 'package:fireapp/data/persistence/app_config_persistence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('AppConfigPersistence', () {
    AppConfigPersistence appConfigPersistence = AppConfigPersistence();

    test('Initial localServerUrl is null', () {
      expect(appConfigPersistence.localServerUrl, isNull);
    });

    test('Setting localServerUrl', () {
      const url = 'http://example.com';
      appConfigPersistence.localServerUrl = url;
      expect(appConfigPersistence.localServerUrl, equals(url));
    });
  });
}
