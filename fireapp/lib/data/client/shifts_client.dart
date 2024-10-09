import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/shift.dart';

@injectable
class ShiftsClient {
  final RestClient restClient;
  ShiftsClient(this.restClient);

  Future<List<Shift>> getVolunteerShifts(int userId) {
    return restClient.getShifts(userId);
  }

  Future<void> optimiseShifts() {
    return restClient.optimiseShifts();
  }
}
