import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/dto/volunteer_information_dto.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/role_request.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/reference/volunteer_role.dart';
import '../../domain/models/role_response.dart';

@injectable
class VolunteerInformationClient{

  final RestClient restClient;
  VolunteerInformationClient(this.restClient);

  Future<VolunteerInformationDto> getVolunteerInformation(String volunteerId) {
    return restClient.getVolunteerInformation(volunteerId);
  }

  Future<void> updateRoles(int userId,List<VolunteerRole> activeRoles, List<VolunteerRole> inactiveRoles) async {
    for (VolunteerRole role in activeRoles) {
      restClient.updateVolunteerRoles(userId, role.id);
    }
    for (VolunteerRole role in inactiveRoles) {
      restClient.patchVolunteerRoles(userId, role.id);
    }
  }

}