import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/volunteer_information_client.dart';
import 'package:fireapp/domain/models/dto/volunteer_information_dto.dart';
import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:fireapp/domain/models/role_request.dart';
import 'package:floor/floor.dart';
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

    test('updateRoles should call restClient.updateVolunteerRoles and restClient.patchVolunteerRoles', () async {
      const userId = 1;
      final activeRoles = [
        VolunteerRole(
          id: 1,
          name: "Role 1",
          updated: DateTime.now(),
          created: DateTime.now()
        ),
        VolunteerRole(
          id: 2,
          name: "Role 2",
          updated: DateTime.now(),
          created: DateTime.now()
        )
      ];
      final inactiveRoles = [
        VolunteerRole(
          id: 3,
          name: "Role 3",
          updated: DateTime.now(),
          created: DateTime.now()
        )
      ];

      await volunteerInformationClient.updateRoles(userId, activeRoles, inactiveRoles);
      verify(mockRestClient.updateVolunteerRoles(userId, 1)).called(1);
      verify(mockRestClient.updateVolunteerRoles(userId, 2)).called(1);
      verify(mockRestClient.patchVolunteerRoles(userId, 3)).called(1);
    });

  });
}
