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
    var listing = const VolunteerListing(
        volunteerId: "6",
        firstName: "test",
        lastName: "test",
        qualification: ["test", "test"]
    );

    when(mockRestClient.volunteerList()).thenAnswer((_) => Future.value([
      listing
    ]));

    final expected = [
      listing
    ];
    final result = await volunteerClient.volunteerList();

    expect(result, expected);
  });
}
