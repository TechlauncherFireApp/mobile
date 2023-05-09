import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/reference_data_client.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<RestClient>(),
])
import 'reference_data_client_test.mocks.dart';

void main() {
  late ReferenceDataClient referenceDataClient;
  late MockRestClient mockRestClient;

  setUp(() {
    mockRestClient = MockRestClient();
    referenceDataClient = ReferenceDataClient(mockRestClient);
  });

  group('getQualifications', () {
    test('returns a list of Qualification objects', () async {
      final qualifications = [
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

      when(mockRestClient.getQualifications())
          .thenAnswer((_) => Future.value(qualifications));

      final result = await referenceDataClient.getQualifications();

      expect(result, isA<List<Qualification>>());
      expect(result, equals(qualifications));
    });
  });
  group('getRoles', () {
    test('returns a list of VolunteerRole objects', () async {
      final roles = [
        VolunteerRole(
          id: 1,
          name: 'Role 1',
          updated: DateTime.now(),
          created: DateTime.now(),
        ),
        VolunteerRole(
          id: 2,
          name: 'Role 2',
          updated: DateTime.now(),
          created: DateTime.now(),
        )
      ];

      when(mockRestClient.getRoles())
          .thenAnswer((_) => Future.value(roles));

      final result = await referenceDataClient.getRoles();

      expect(result, isA<List<VolunteerRole>>());
      expect(result, equals(roles));
    });
  });
}
