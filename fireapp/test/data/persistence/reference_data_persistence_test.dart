import 'package:fireapp/data/persistence/db/reference_data_db_dao.dart';
import 'package:fireapp/data/persistence/db/reference_data_db_metadata_dao.dart';
import 'package:fireapp/data/persistence/reference_data_persistence.dart';
import 'package:fireapp/domain/models/reference/reference_data.dart';
import 'package:fireapp/domain/models/reference/reference_data_db.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateNiceMocks([
  MockSpec<ReferenceDataDbDao>(),
  MockSpec<ReferenceDataDbMetadataDao>(),
])
import 'reference_data_persistence_test.mocks.dart';

void main() {
  late ReferenceDataDbDao dataDbDao;
  late ReferenceDataDbMetadataDao dataDbMetadataDao;
  late ReferenceDataPersistence persistence;

  setUp(() {
    dataDbDao = MockReferenceDataDbDao();
    dataDbMetadataDao = MockReferenceDataDbMetadataDao();
    persistence = ReferenceDataPersistence(dataDbDao, dataDbMetadataDao);
  });

  group('ReferenceDataPersistence', () {
    final qualificationData = [
      ReferenceDataDb(
        pk: 'qualification_1',
        type: 'qualification',
        id: 1,
        name: 'Qualification 1',
        code: null,
        updated: DateTime.now().millisecondsSinceEpoch,
        created: DateTime.now().millisecondsSinceEpoch,
      ),
      ReferenceDataDb(
        pk: 'qualification_2',
        type: 'qualification',
        id: 2,
        name: 'Qualification 2',
        code: null,
        updated: DateTime.now().millisecondsSinceEpoch,
        created: DateTime.now().millisecondsSinceEpoch,
      ),
    ];

    test('getLastUpdated returns null if metadata is not found', () async {
      when(dataDbMetadataDao.getByType('qualification')).thenAnswer((_) async => null);
      final lastUpdated = await persistence.getLastUpdated(ReferenceDataType.qualification);
      expect(lastUpdated, isNull);
    });

    test('getLastUpdated returns lastRefreshed date from metadata', () async {
      final metadata = ReferenceDataDbMetadata(
        type: 'qualification',
        lastRefreshed: DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch,
      );
      when(dataDbMetadataDao.getByType('qualification')).thenAnswer((_) async => metadata);
      final lastUpdated = await persistence.getLastUpdated(ReferenceDataType.qualification);
      expect(lastUpdated, equals(DateTime.fromMillisecondsSinceEpoch(metadata.lastRefreshed)));
    });

    test('save saves reference data and metadata to the database', () async {
      when(dataDbDao.insertReferenceData(qualificationData)).thenAnswer((_) async {});
      await persistence.save(ReferenceDataType.qualification, qualificationData);
      verify(dataDbDao.insertReferenceData(qualificationData)).called(1);
    });

    test('getReferenceData returns reference data for a given type', () async {
      when(dataDbDao.getByType('qualification')).thenAnswer((_) async => qualificationData);
      final result = await persistence.getReferenceData(ReferenceDataType.qualification);
      expect(result, equals(qualificationData));
    });
  });
}
