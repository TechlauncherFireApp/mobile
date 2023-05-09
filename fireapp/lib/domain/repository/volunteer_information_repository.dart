import 'package:fireapp/data/client/volunteer_information_client.dart';
import 'package:fireapp/domain/models/dto/volunteer_information_dto.dart';
import 'package:fireapp/domain/models/reference/reference_data.dart';
import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:injectable/injectable.dart';

import '../../global/access.dart';
import '../models/reference/qualification.dart';
import 'authentication_repository.dart';

@injectable
class VolunteerInformationRepository {

  final ReferenceDataRepository _reference;
  final AuthenticationRepository _authentication;
  final VolunteerInformationClient _client;
  VolunteerInformationRepository(this._client, this._reference, this._authentication);

  Future<VolunteerInformation> getVolunteerInformation(String ID) async {
    VolunteerInformationDto volunteerInformation = await _client.getVolunteerInformation(ID);
    List<Qualification> qualifications = await _reference.getQualifications();
    return VolunteerInformation(
      ID: volunteerInformation.ID,
      firstName: volunteerInformation.firstName,
      lastName: volunteerInformation.lastName,
      email: volunteerInformation.email,
      mobileNo: volunteerInformation.mobileNo,
      prefHours: volunteerInformation.prefHours,
      expYears: volunteerInformation.expYears,
      qualifications: volunteerInformation.qualifications.map((e) =>
          qualifications.firstWhere((element) => "${element.id}" == e)).toList(),
      availabilities: AvailabilityField(
        monday: volunteerInformation.availabilities.monday,
        tuesday: volunteerInformation.availabilities.tuesday,
        wednesday: volunteerInformation.availabilities.wednesday,
        thursday: volunteerInformation.availabilities.thursday,
        friday: volunteerInformation.availabilities.friday,
        saturday: volunteerInformation.availabilities.saturday,
        sunday: volunteerInformation.availabilities.sunday,
      ),
      possibleRoles: volunteerInformation.possibleRoles,
    );
  }

  Future<void> updateRoles(List<VolunteerRole> roles) async {
    var inactiveRoles = (await _reference.getRoles()).where((element) => !roles.any((role) => role.id == element.id)).toList();
    var userID = (await _authentication.getCurrentSession())?.userId;

    // Check if userId is null and throw an exception if it is
    if (userID == null) {
      throw Exception('User ID is null. Cannot update roles without a valid user ID.');
    }

    await _client.updateRoles(userID, roles, inactiveRoles);
  }

}