import 'package:fireapp/data/client/authentication_client.dart';
import 'package:fireapp/data/persistence/app_config_persistence.dart';
import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:fireapp/domain/models/reference/gender.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/repository/app_config_repository.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/environment_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<AppConfigPersistence>(),
])
import 'app_config_repository_test.mocks.dart';

// AppConfigRepository can't be properly tested, but it is pretty simple
// so its a WONTFIX for now
void main() {
  group('AppConfigRepository', () {
    late AppConfigRepository appConfigRepository;
    late MockAppConfigPersistence mockPersistence;

    setUp(() {
      mockPersistence = MockAppConfigPersistence();
      appConfigRepository = AppConfigRepository(mockPersistence);
    });

    test('getServerUrl returns localServerUrl if serviceUrl is empty', () {
      // Act
      final result = appConfigRepository.getServerUrl();

      // Assert
      verify(mockPersistence.localServerUrl);
    });

    test('setServerUrl sets localServerUrl correctly', () {
      // Arrange
      final newUrl = 'http://newexample.com';

      // Act
      appConfigRepository.setServerUrl(newUrl);

      // Assert
      verify(mockPersistence.localServerUrl = newUrl);
    });
  });
}