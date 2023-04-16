import 'package:fireapp/data/client/reference_data_client.dart';
import 'package:fireapp/data/persistence/reference_data_persistence.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/reference/reference_data.dart';
import 'package:fireapp/domain/models/reference/reference_data_db.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<ReferenceDataClient>(),
  MockSpec<ReferenceDataPersistence>()
])
import 'reference_data_repository_test.mocks.dart';

void main() {
  late ReferenceDataRepository repository;
  late MockReferenceDataClient client;
  late MockReferenceDataPersistence persistence;

  group('getQualifications', () {
    setUp(() {
      client = MockReferenceDataClient();
      persistence = MockReferenceDataPersistence();
      repository = ReferenceDataRepository(client, persistence);
    });

    final currentTime = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch
    );
    final qualification1 = Qualification(
      id: 1,
      name: 'Qualification 1',
      created: currentTime,
      updated: currentTime,
    );
    final qualification2 = Qualification(
      id: 2,
      name: 'Qualification 2',
      created: currentTime,
      updated: currentTime,
    );

    test('returns data from persistence if not expired', () async {
      // Arrange

      final lastUpdated = DateTime
          .now();
      final dbData = [
        ReferenceDataDb(
          pk: 'qualification_1',
          type: 'qualification',
          id: 1,
          name: 'Qualification 1',
          code: null,
          created: currentTime.millisecondsSinceEpoch,
          updated: currentTime.millisecondsSinceEpoch,
        ),
        ReferenceDataDb(
          pk: 'qualification_2',
          type: 'qualification',
          id: 2,
          name: 'Qualification 2',
          code: null,
          created: currentTime.millisecondsSinceEpoch,
          updated: currentTime.millisecondsSinceEpoch,
        ),
      ];
      when(persistence.getLastUpdated(ReferenceDataType.qualification)).thenAnswer((_) async => lastUpdated);
      when(persistence.getReferenceData(ReferenceDataType.qualification)).thenAnswer((_) async => dbData);
      when(client.getQualifications()).thenAnswer((_) async => []);

      // Act
      final result = await repository.getQualifications();

      // Assert
      verifyNever(client.getQualifications());
      expect(result, containsAll([qualification1, qualification2]));
    });

    test('fetches data from client if expired', () async {
      // Arrange
      final currentTime = DateTime
          .now()
          .millisecondsSinceEpoch;
      final dbData = [
        ReferenceDataDb(
          pk: 'qualification_1',
          type: 'qualification',
          id: 1,
          name: 'Qualification 1',
          code: null,
          created: currentTime,
          updated: currentTime,
        ),
      ];
      when(persistence.getLastUpdated(ReferenceDataType.qualification))
          .thenAnswer((_) async => DateTime.fromMillisecondsSinceEpoch(
            currentTime - ReferenceDataRepository.lifetime - 50000
          )
      );
      when(client.getQualifications())
          .thenAnswer((_) async => [qualification1, qualification2]);

      // Act
      final result = await repository.getQualifications();

      // Assert
      verifyNever(persistence.getReferenceData(ReferenceDataType.qualification));
      verify(client.getQualifications()).called(1);
      expect(result, containsAll([qualification1, qualification2]));
    });
  });
}