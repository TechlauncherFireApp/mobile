import 'package:fireapp/data/client/reference_data_client.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<ReferenceDataClient>()
])
import 'reference_data_repository_test.mocks.dart';

void main() {
  group('ReferenceDataRepository', () {
    late ReferenceDataRepository referenceDataRepository;
    late MockReferenceDataClient mockClient;

    setUp(() {
      mockClient = MockReferenceDataClient();
      referenceDataRepository = ReferenceDataRepository(mockClient);
    });

    test('getQualifications() returns a list of Qualification objects', () async {
      final expectedQualifications = [
        Qualification(
          id: 1,
          name: 'Qualification 1',
          updated: DateTime.now(),
          created: DateTime.now(),
        ),
        Qualification(
          id: 2,
          name: 'Qualification 2',
          updated: DateTime.now(),
          created: DateTime.now(),
        )
      ];
      when(mockClient.getQualifications()).thenAnswer((_) => Future.value(expectedQualifications));

      final qualifications = await referenceDataRepository.getQualifications();

      expect(qualifications, equals(expectedQualifications));
    });
  });
}