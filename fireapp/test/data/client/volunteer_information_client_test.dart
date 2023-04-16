import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/volunteer_information_client.dart';
import 'package:fireapp/domain/models/dto/volunteer_information_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<RestClient>(),
])
import 'volunteer_information_client_test.mocks.dart';

void main() {
  group('VolunteerInformationClient', () {
    late RestClient mockRestClient;
    late VolunteerInformationClient volunteerInformationClient;

    setUp(() {
      mockRestClient = MockRestClient();
      volunteerInformationClient = VolunteerInformationClient(mockRestClient);
    });

    test('getVolunteerInformation returns the DTO object from the RestClient', () async {
      // Arrange
      const volunteerId = '123';
      const expectedDto = VolunteerInformationDto(
        ID: volunteerId,
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        mobileNo: '555-1234',
        prefHours: 20,
        expYears: 2,
        qualifications: ['1', '2'],
        availabilities: AvailabilityFieldDto(
          monday: [[1,8]],
          tuesday: [[]],
          wednesday: [[]],
          thursday: [[]],
          friday: [[]],
          saturday: [[]],
          sunday: [[]],
        ),
        possibleRoles: ['Role A', 'Role B'],
      );

      when(mockRestClient.getVolunteerInformation(volunteerId))
          .thenAnswer((_) async => expectedDto);

      // Act
      final result = await volunteerInformationClient.getVolunteerInformation(volunteerId);

      // Assert
      expect(result, equals(expectedDto));
      verify(mockRestClient.getVolunteerInformation(volunteerId)).called(1);
    });
  });
}
