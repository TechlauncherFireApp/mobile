import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/dto/volunteer_information_dto.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/reference/volunteer_role.dart';

@injectable
class VolunteerInformationClient{

  final RestClient restClient;
  VolunteerInformationClient(this.restClient);

  Future<VolunteerInformationDto> getVolunteerInformation(String volunteerId) {
    return restClient.getVolunteerInformation(volunteerId);
  }

  Future<void> updateRoles(int userId,List<VolunteerRole> activeRoles, List<VolunteerRole> inactiveRoles) async {
    for (VolunteerRole role in activeRoles) {
      restClient.updateVolunteerRoles(userId.toString(), role.id.toString());
    }
    for (VolunteerRole role in inactiveRoles) {
      restClient.patchVolunteerRoles(userId.toString(), role.id.toString());
    }
  }

}