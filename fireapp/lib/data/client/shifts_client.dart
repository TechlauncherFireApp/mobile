import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/shift.dart';

@injectable
class ShiftsClient {
  final RestClient restClient;
  ShiftsClient(this.restClient);

  //TODO get list of all unavailability events from user from backend
  Future<List<Shift>> getVolunteerShifts(int userId) {
    // Generate some mock shifts
    List<Shift> mockShifts = [
      Shift(
        shiftId: 1,
        startTime: DateTime.now().add(Duration(days: 1, hours: 9)),  // Tomorrow at 9 AM
        endTime: DateTime.now().add(Duration(days: 1, hours: 17)),   // Tomorrow at 5 PM
      ),
      Shift(
        shiftId: 2,
        startTime: DateTime.now().add(Duration(days: 2, hours: 8)),  // Day after tomorrow at 8 AM
        endTime: DateTime.now().add(Duration(days: 2, hours: 16)),   // Day after tomorrow at 4 PM
      ),
      Shift(
        shiftId: 3,
        startTime: DateTime.now().add(Duration(days: 3, hours: 10)), // Three days from now at 10 AM
        endTime: DateTime.now().add(Duration(days: 3, hours: 18)),   // Three days from now at 6 PM
      ),
      Shift(
        shiftId: 4,
        startTime: DateTime.now().add(Duration(days: 4, hours: 11)), // Four days from now at 11 AM
        endTime: DateTime.now().add(Duration(days: 4, hours: 19)),   // Four days from now at 7 PM
      ),
    ];

    // Return the mock shifts wrapped in a Future
    return Future.value(mockShifts);
  }
}
