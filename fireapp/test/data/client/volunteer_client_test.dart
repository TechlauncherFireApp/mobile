import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/volunteer_client.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<RestClient>(),
])
import 'volunteer_client_test.mocks.dart';

void main() {
  late VolunteerClient volunteerClient;
  late MockRestClient mockRestClient;

  setUp(() {
    mockRestClient = MockRestClient();
    volunteerClient = VolunteerClient(mockRestClient);
  });

  test('volunteerList returns transformed volunteer listings', () async {
    final volunteerListings = {
      'id1': 'John Doe',
      'id2': 'Jane Smith',
    };
    when(mockRestClient.volunteerList()).thenAnswer((_) => Future.value(volunteerListings));

    final expected = [
      const VolunteerListing(volunteerId: 'id1', name: 'John Doe'),
      const VolunteerListing(volunteerId: 'id2', name: 'Jane Smith'),
    ];
    final result = await volunteerClient.volunteerList();

    expect(result, expected);
  });
}
