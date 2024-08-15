import 'package:fireapp/domain/repository/shifts_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/models/shift.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../domain/request_state.dart';
import '../fireapp_view_model.dart';

@injectable
class VolunteerHomeViewModel extends FireAppViewModel {
  //Load in authentication and unavailability actions
  late final AuthenticationRepository _authenticationRepository;
  late final ShiftsRepository _shiftsRepository;

  // List of Volunteer's unavailability events
  final BehaviorSubject<RequestState<List<Shift>>> _shifts =
      BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<List<Shift>>> get shiftsStream => _shifts.stream;

  // Loading State controllers
  final BehaviorSubject<RequestState<void>> _loadingState =
      BehaviorSubject.seeded(RequestState.success(null));
  Stream<RequestState<void>> get loadingState => _loadingState.stream;

  VolunteerHomeViewModel(
      this._authenticationRepository, this._shiftsRepository);

  // write your functions and logic etc

  //TODO retrieve shifts
  Future<void> fetchShifts() async {
    return;
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }
}
