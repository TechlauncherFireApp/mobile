import 'dart:async';

import 'package:fireapp/domain/models/calendar_event.dart';
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

  final BehaviorSubject<List<CalendarEvent>> _displayEvents =
      BehaviorSubject.seeded([]);
  Stream<List<CalendarEvent>> get displayEventsStream => _displayEvents.stream;

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

  Future<void> fetchUnavailabilityEvents() async {
    _loadingState.add(RequestState.loading());
    try {
      var userID =
          (await _authenticationRepository.getCurrentSession())?.userId;
      // Check if userId is null and throw an exception if it is
      if (userID == null) {
        throw Exception(
            'User ID is null. Cannot update roles without a valid user ID.');
      }
      print("Fetching..");
      var events =
          await _unavailabilityRepository.getUnavailabilityEvents(userID);
      if (events.isEmpty) {
        events = [];
      }

      _unavailabilityEvents.add(RequestState.success(events));
    } catch (e, stacktrace) {
      logger.e(e, stackTrace: stacktrace);
      print("FAILED");
      _unavailabilityEvents.add(RequestState.exception(e));
    } finally {}
  }

  bool doPeriodsOverlap(
      DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    return (start1.isBefore(end2) || isSameDay(start1, end2)) &&
        (start2.isBefore(end1) || isSameDay(start2, end1));
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.difference(date2).inDays == 0;
  }

  List filterEvents(
      BehaviorSubject<RequestState<List<UnavailabilityTime>>> eventsStream) {
    final eventsState = eventsStream.value;
    // Assuming eventsState contains the list of UnavailabilityTime objects
    if (eventsState is SuccessRequestState<List<UnavailabilityTime>>) {
      final unavailabilityList = eventsState.result;
      // Filter by month and year
      final filteredList = unavailabilityList.where((unavailability) {
        final selectedStartTime =
            DateTime(_selectedYear.value, _selectedMonth.value, 1);
        DateTime firstDayOfNextMonth =
            DateTime(_selectedYear.value, _selectedMonth.value + 1, 1);
        final selectedEndTime =
            firstDayOfNextMonth.subtract(const Duration(days: 1));
        return doPeriodsOverlap(unavailability.startTime,
            unavailability.endTime, selectedStartTime, selectedEndTime);
      }).toList();
      return filteredList;
    }
    return [];
  }

  Future<void> loadAndSetDisplayEvents() async {
    await fetchUnavailabilityEvents();
    var filteredEvents = filterEvents(_unavailabilityEvents);
    print("Filtered Events for ${_selectedMonth.value}");
    print(filteredEvents);
    if (filteredEvents.isNotEmpty) {
      List<CalendarEvent> displayEventList = [];
      for (var event in filteredEvents) {
        final firstDayOfMonth =
            DateTime(_selectedYear.value, _selectedMonth.value, 1);
        final startDate = (event.startTime.isBefore(firstDayOfMonth) &&
                !isSameDay(event.startTime, firstDayOfMonth))
            ? firstDayOfMonth
            : event.startTime;
        DateTime firstDayOfNextMonth =
            DateTime(_selectedYear.value, _selectedMonth.value + 1, 1);
        final lastDayOfMonth =
            firstDayOfNextMonth.subtract(const Duration(days: 1));
        final endDate = (event.endTime.isAfter(lastDayOfMonth) &&
                !isSameDay(event.endTime, lastDayOfMonth))
            ? lastDayOfMonth
            : event.endTime;
        final numDays = endDate.difference(startDate).inDays;

        for (int i = 0; i <= numDays; i++) {
          String displayTimeLabel;
          // If a single day event
          if (i == 0 && numDays == 0) {
            displayTimeLabel =
                "${startDate.hour}:${startDate.minute} - ${endDate.hour}:${endDate.minute} ";
          }
          // For first day in the event
          else if (i == 0) {
            displayTimeLabel =
                "${startDate.hour}:${startDate.minute} - Midnight";
          }
          // For the last day in the event
          else if (i == numDays) {
            displayTimeLabel = "Midnight - ${endDate.hour}:${endDate.minute}";
          }
          // All days in between
          else {
            displayTimeLabel = "All Day";
          }
          displayEventList
              .add(CalendarEvent(event: event, displayTime: displayTimeLabel));
        }
      }
      _displayEvents.add(displayEventList);

      for (int i = 0; i < displayEventList.length; i++) {
        print(
            "${displayEventList[i].displayTime} |${displayEventList[i].event.eventId}");
      }
    } else {
      _displayEvents.add([]);
    }
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
