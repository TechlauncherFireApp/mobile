import 'package:fireapp/data/client/volunteer_client.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/repository/volunteer_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<VolunteerClient>(),
])
import 'volunteer_repository_test.mocks.dart';

void main() {
  late VolunteerRepository repository;
  late MockVolunteerClient mockClient;

  setUp(() {
    mockClient = MockVolunteerClient();
    repository = VolunteerRepository(mockClient);
  });

  test('volunteerList should return a list of VolunteerListing', () async {
    // Arrange
    final expectedList = [
      const VolunteerListing(
        volunteerId: '1',
        name: 'John Doe'
      ),
      const VolunteerListing(
        volunteerId: '2',
        name: 'Jane Doe',
      ),
    ];

    when(mockClient.volunteerList()).thenAnswer((_) async => expectedList);

    // Act
    final result = await repository.volunteerList();

    // Assert
    expect(result, equals(expectedList));
    verify(mockClient.volunteerList()).called(1);
  });
}
