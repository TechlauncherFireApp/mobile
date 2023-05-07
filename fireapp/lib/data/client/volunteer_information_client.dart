import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/dto/volunteer_information_dto.dart';
import 'package:injectable/injectable.dart';

@injectable
class VolunteerInformationClient{

  final RestClient restClient;
  VolunteerInformationClient(this.restClient);

  Future<VolunteerInformationDto> getVolunteerInformation(String volunteerId) {
    return restClient.getVolunteerInformation(volunteerId);
  }

  Future<void> updateRoles(String id, List<String> roles) async{
    return restClient.updateVolunteerRoles(id, roles.join(","));
  }
}