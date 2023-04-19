import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReferenceDataClient {

  final RestClient restClient;
  ReferenceDataClient(this.restClient);

  Future<List<Qualification>> getQualifications() {
    return restClient.getQualifications();
  }

  Future<List<VolunteerRole>> getRoles() {
    return restClient.getRoles();
  }
}