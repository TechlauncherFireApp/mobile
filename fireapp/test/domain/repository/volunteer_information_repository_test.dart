import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fireapp/data/client/volunteer_information_client.dart';
import 'package:fireapp/domain/models/dto/volunteer_information_dto.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:fireapp/domain/repository/volunteer_information_repository.dart';

@GenerateNiceMocks([
  MockSpec<VolunteerInformationClient>(),
  MockSpec<ReferenceDataRepository>(),
  MockSpec<AuthenticationRepository>(),
])
import 'volunteer_information_repository_test.mocks.dart';

void main() {
  group('VolunteerInformationRepository', () {
    late VolunteerInformationRepository volunteerInformationRepository;
    late MockVolunteerInformationClient mockClient;
    late MockReferenceDataRepository mockReferenceDataRepository;
    late MockAuthenticationRepository mockAuthenticationRepository;

    setUp(() {
      mockClient = MockVolunteerInformationClient();
      mockReferenceDataRepository = MockReferenceDataRepository();
      mockAuthenticationRepository = MockAuthenticationRepository();
      volunteerInformationRepository = VolunteerInformationRepository(mockClient, mockReferenceDataRepository, mockAuthenticationRepository);
    });

    test('getVolunteerInformation() returns a VolunteerInformation object', () async {
      const expectedVolunteerInformationDto = VolunteerInformationDto(
        ID: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'johndoe@example.com',
        mobileNo: '1234567890',
        prefHours: 10,
        expYears: 2,
        qualification: ['Qualification 1', 'Qualification 2'],
        availabilities: AvailabilityFieldDto(
          monday: [[1,8]],
          tuesday: [[]],
          wednesday: [[]],
          thursday: [[]],
          friday: [[]],
          saturday: [[]],
          sunday: [[]],
        ),
        possibleRoles: ['Role 1', 'Role 2'],
      );
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

      final expectedVolunteerInformation = VolunteerInformation(
        ID: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'johndoe@example.com',
        mobileNo: '1234567890',
        prefHours: 10,
        expYears: 2,
        qualifications: expectedQualifications,
        availabilities: const AvailabilityField(
          monday: [[1,8]],
          tuesday: [[]],
          wednesday: [[]],
          thursday: [[]],
          friday: [[]],
          saturday: [[]],
          sunday: [[]],
        ),
        possibleRoles: ['Role 1', 'Role 2'],
      );

      when(mockClient.getVolunteerInformation('1')).thenAnswer((_) => Future.value(expectedVolunteerInformationDto));
      when(mockReferenceDataRepository.getQualifications()).thenAnswer((_) => Future.value(expectedQualifications));

      final volunteerInformation = await volunteerInformationRepository.getVolunteerInformation('1');

      expect(volunteerInformation, equals(expectedVolunteerInformation));
    });
    test('successfully updates roles', () async {
      // Arrange
      var roles = [VolunteerRole(id: 1, name: 'Role 1', updated: DateTime.now(), created: DateTime.now())];
      var allRoles = [VolunteerRole(id: 1, name: 'Role 1', updated: DateTime.now(), created: DateTime.now()),
        VolunteerRole(id: 2, name: 'Role 2', updated: DateTime.now(), created: DateTime.now())];
      var userId = 12345;

      when(mockReferenceDataRepository.getRoles()).thenAnswer((_) async => allRoles);
      when(mockAuthenticationRepository.getCurrentSession()).thenAnswer((_) async => TokenResponse(userId: userId, accessToken: 'token', role: 'role'));

      // Act
      await volunteerInformationRepository.updateRoles(roles);

      // Assert
      verify(mockClient.updateRoles(userId, roles, [allRoles[1]])).called(1);
    });

    test('throws an exception when user ID is null', () async {
      // Arrange
      var roles = [VolunteerRole(id: 1, name: 'Role 1', updated: DateTime.now(), created: DateTime.now())];
      when(mockAuthenticationRepository.getCurrentSession()).thenAnswer((_) async => null);

      // Act & Assert
      expect(() => volunteerInformationRepository.updateRoles(roles), throwsA(isA<Exception>()));
    });
  });
}
