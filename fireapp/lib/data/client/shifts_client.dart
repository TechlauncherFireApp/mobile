import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/shift.dart';

@injectable
class ShiftsClient {
  final RestClient restClient;
  ShiftsClient(this.restClient);

  //TODO get list of all unavailability events from user from backend
  Future<List<Shift>> getVolunteerShifts(int userId) {
    return Future.value([]);
  }
}
