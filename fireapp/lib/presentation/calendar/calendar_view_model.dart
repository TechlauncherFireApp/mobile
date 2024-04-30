import 'dart:async';

import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/request_state.dart';
import 'package:fireapp/domain/repository/unavailability_repository.dart';

import '../../global/di.dart';
import 'calendar_navigation.dart';

@injectable
class CalendarViewModel extends FireAppViewModel
    implements NavigationViewModel<CalendarNavigation> {
  //Load in authentication and unavailability actions
  late final AuthenticationRepository _authenticationRepository;
  late final UnavailabilityRepository _unavailabilityRepository;

  final BehaviorSubject<int> _selectedMonth =
  BehaviorSubject.seeded(DateTime.now().month);

  final BehaviorSubject<int> _selectedYear =
  BehaviorSubject.seeded(DateTime.now().year);

  // List of Volunteer's unavailability events
  final BehaviorSubject<RequestState<List<UnavailabilityTime>>>
  _unavailabilityEvents = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<List<UnavailabilityTime>>> get eventsStream =>
      _unavailabilityEvents.stream;

  // Loading State controllers
  final BehaviorSubject<RequestState<void>> _loadingState =
  BehaviorSubject.seeded(RequestState.success(null));
  Stream<RequestState<void>> get loadingState => _loadingState.stream;

  // Navigation handling
  final BehaviorSubject<CalendarNavigation> _navigate = BehaviorSubject();

  @override
  Stream<CalendarNavigation> get navigate => _navigate.stream;

  CalendarViewModel(
      this._authenticationRepository, this._unavailabilityRepository);

  void fetchUnavailabilityEvents() {
    _loadingState.add(RequestState.loading());
    (() async {
      try {
        var userID =
            (await _authenticationRepository.getCurrentSession())?.userId;
        // Check if userId is null and throw an exception if it is
        if (userID == null) {
          throw Exception(
              'User ID is null. Cannot update roles without a valid user ID.');
        }
        print("Fetching..");
        var events = await _unavailabilityRepository.getUnavailabilityEvents(userID);
        if (events.isEmpty) {
          events = [];
        }

        _unavailabilityEvents.add(RequestState.success(events));
      } catch (e, stacktrace) {
        logger.e(e, stackTrace: stacktrace);
        print("FAILED");
        _unavailabilityEvents.add(RequestState.exception(e));
      }
      print("done");
    })();
  }


  List filterEvents(
      BehaviorSubject<RequestState<List<UnavailabilityTime>>> eventsStream) {
    final eventsState = eventsStream.value;
    // Assuming eventsState contains the list of UnavailabilityTime objects
    if(eventsState is SuccessRequestState<List<UnavailabilityTime>>){
      final unavailabilityList = eventsState.result;
      // Filter by month and year
      final filteredList = unavailabilityList.where((unavailability) {
        final startMonth = unavailability.startTime.month;
        final startYear = unavailability.startTime.year;
        final endMonth = unavailability.endTime.month;
        final endYear = unavailability.endTime.year;

        return (startYear <= _selectedYear.value && startMonth <= _selectedMonth.value) ||
            (endYear >= _selectedYear.value && endMonth >= _selectedMonth.value);
      }).toList();
      return filteredList;
    }
    return [];
  }

  void deleteUnavailability(int eventID) {
    _loadingState.add(RequestState.loading());
    (() async {
      try {
        var userID =
            (await _authenticationRepository.getCurrentSession())?.userId;

        // Check if userId is null and throw an exception if it is
        if (userID == null) {
          throw Exception(
              'User ID is null. Cannot update without a valid user ID.');
        }
        await _unavailabilityRepository.deleteUnavailabilityEvent(
            userID, eventID);
        _loadingState.add(RequestState.success(null));
      } catch (e, stacktrace) {
        logger.e(e, stackTrace: stacktrace);
        _loadingState.add(RequestState.exception(e));
      }
    })();
  }

  void editEventNavigate(eventID) {
    //navigate.add()
  }

  void updateSelectedMonth(int month) {
    if (month < 1 && month > 12) {
      return;
    }
    _selectedMonth.value = month;
  }

  void updateSelectedYear(int year) {
    if (year < 0) {
      return;
    }
    _selectedYear.value = year;
  }

  @override
  Future<void> dispose() async {
    _selectedMonth.close();
    _selectedYear.close();
    _navigate.close();
    _loadingState.close();
  }
}
