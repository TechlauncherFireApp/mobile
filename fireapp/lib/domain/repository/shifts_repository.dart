import 'package:injectable/injectable.dart';
import '../../data/client/shifts_client.dart';
import '../models/shift.dart';

@injectable
class ShiftsRepository {
  final ShiftsClient shiftsClient;

  ShiftsRepository(this.shiftsClient);

  Future<List<Shift>> getVolunteerShifts(int userId) {
    return shiftsClient.getVolunteerShifts(userId);
  }
}
