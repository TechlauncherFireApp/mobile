import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:injectable/injectable.dart';

@injectable
class VolunteerClient {

  final RestClient restClient;
  VolunteerClient(this.restClient);

  Future<List<VolunteerListing>> volunteerList() async {
    return restClient.volunteerList();
  }
}