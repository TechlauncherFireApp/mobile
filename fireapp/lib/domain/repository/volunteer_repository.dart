import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/volunteer_client.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:injectable/injectable.dart';

@injectable
class VolunteerRepository {

  final VolunteerClient volunteerClient;
  VolunteerRepository(this.volunteerClient);

  Future<List<VolunteerListing>> volunteerList() async {
    return volunteerClient.volunteerList();
  }
}