import 'package:fireapp/domain/repository/shifts_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/models/shift.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../domain/request_state.dart';
import '../fireapp_view_model.dart';
import '../../global/di.dart';


@injectable
class VolunteerHomeViewModel extends FireAppViewModel {
  //Load in authentication and unavailability actions
  late final AuthenticationRepository _authenticationRepository;
  late final ShiftsRepository _shiftsRepository;

  // List of Volunteer's unavailability events
  final BehaviorSubject<RequestState<List<Shift>>> _shifts =
      BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<List<Shift>>> get shiftsStream => _shifts.stream;
  VolunteerHomeViewModel(
      this._authenticationRepository, this._shiftsRepository);
  Future<void> fetchShifts() async {
    _shifts.add(RequestState.loading());
    try {
      var userID =
          (await _authenticationRepository.getCurrentSession())?.userId;
      // Check if userId is null and throw an exception if it is
      if (userID == null) {
        throw Exception(
            'User ID is null. Cannot fetch shift without a valid user ID.');
      }
        var shifts =
        await _shiftsRepository.getVolunteerShifts(userID);
        _shifts.add(RequestState.success(shifts));
    } catch (e, stacktrace) {
      logger.e(e, stackTrace: stacktrace);
      _shifts.add(RequestState.exception(e));
    }
    return;
  }
  @override
  Future<void> dispose() async {
    _shifts.close();
  }
}
