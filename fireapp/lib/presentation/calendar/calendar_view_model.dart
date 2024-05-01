import 'dart:async';

import 'package:fireapp/domain/models/calendar_event.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
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

  // List of restructured UI event data structures
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

  // Fetch the volunteer's unavailability events
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
      var events =
          await _unavailabilityRepository.getUnavailabilityEvents(userID);
      if (events.isEmpty) {
        events = [];
      }
      _unavailabilityEvents.add(RequestState.success(events));
    } catch (e, stacktrace) {
      logger.e(e, stackTrace: stacktrace);
      _unavailabilityEvents.add(RequestState.exception(e));
    } finally {}
  }

  // Check if two timeframes overlap
  // (used to check if an event overlaps with selected month period)
  bool doPeriodsOverlap(
      DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    return (start1.isBefore(end2) || isSameDay(start1, end2)) &&
        (start2.isBefore(end1) || isSameDay(start2, end1));
  }

  //Check if is same day
  bool isSameDay(DateTime date1, DateTime date2) {
    //Restrict to days only (remove exact hour/minutes)
    var d1 = DateTime(date1.year, date1.month, date1.day);
    var d2 = DateTime(date2.year, date2.month, date2.day);
    return d1.difference(d2).inDays == 0;
  }

  // Filter all unavailability events to the selected month period
  List<UnavailabilityTime> filterEvents(
      List<UnavailabilityTime> unavailabilityList) {
    // Filter events that overlap between selected month and year
    final filteredList = unavailabilityList.where((unavailability) {
      final selectedStartTime =
          DateTime(_selectedYear.value, _selectedMonth.value, 1);
      DateTime firstDayOfNextMonth =
          DateTime(_selectedYear.value, _selectedMonth.value + 1, 1);
      final selectedEndTime =
          firstDayOfNextMonth.subtract(const Duration(days: 1));
      return doPeriodsOverlap(unavailability.startTime, unavailability.endTime,
          selectedStartTime, selectedEndTime);
    }).toList();
    return filteredList;
  }

  Future<void> loadAndSetDisplayEvents() async {
    await fetchUnavailabilityEvents();
    final eventsState = _unavailabilityEvents.value;

    // Check if current state has successfully loaded events
    if (eventsState is SuccessRequestState<List<UnavailabilityTime>>) {
      final unavailabilityList = eventsState.result;
      var filteredEvents = filterEvents(unavailabilityList);
      //Filter the events to the selected month period
      //Take unavailability events and turn them into UI information
      _displayEvents.add(mapToCalendarEvents(filteredEvents));
    } else {
      // No events to be displayed
      _displayEvents.add([]);
    }
  }

  // Convert list of unavailability events to displayable calendar events
  List<CalendarEvent> mapToCalendarEvents(List<UnavailabilityTime> events) {
    List<CalendarEvent> displayEventList = [];
    for (var event in events) {
      final firstDayOfMonth =
          DateTime(_selectedYear.value, _selectedMonth.value, 1);
      //Fix start date
      final startDate = (event.startTime.isBefore(firstDayOfMonth) &&
              !isSameDay(event.startTime, firstDayOfMonth))
          ? firstDayOfMonth
          : event.startTime;
      DateTime firstDayOfNextMonth =
          DateTime(_selectedYear.value, _selectedMonth.value + 1, 1, 23, 59);
      final lastDayOfMonth =
          firstDayOfNextMonth.subtract(const Duration(days: 1));
      //Fix end date
      final endDate = (event.endTime.isAfter(lastDayOfMonth) &&
              !isSameDay(event.endTime, lastDayOfMonth))
          ? lastDayOfMonth
          : event.endTime;
      final numDays = endDate.difference(startDate).inDays;
      // For each day in the event
      for (int i = 0; i <= numDays; i++) {
        var currentDate = startDate;
        currentDate = currentDate.add(Duration(days: i));
        String displayTimeLabel =
            getDisplayTimeLabel(i, numDays, startDate, endDate);
        displayEventList.add(CalendarEvent(
            event: event,
            displayTime: displayTimeLabel,
            displayDate: currentDate));
      }
    }
    for (int i = 0; i < displayEventList.length; i++){
      print(displayEventList[i]);
    }
    return displayEventList;
  }

  // Construct the display time label for an event
  String getDisplayTimeLabel(
      int i, int numDays, DateTime startDate, DateTime endDate) {
    final timeFormat = DateFormat('h:mm a');
    // If a single day event
    if (i == 0 && numDays == 0) {
      return "${timeFormat.format(startDate)} - ${timeFormat.format(endDate)}";
    }
    // Event spans multiple days, and this is the first day
    else if (i == 0 && numDays > 1) {
      return "${timeFormat.format(startDate)} - 11:59 PM";
    }
    // Event spans multiple days, and this is the last day
    else if (i == numDays) {
      return "12:00 AM - ${timeFormat.format(endDate)}";
    }
    // All days in between
    else {
      return "All Day";
    }
  }

  // Delete a volunteers event from calendar
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

  void editEventNavigate(UnavailabilityTime event) {
    _navigate.add(CalendarNavigation.eventDetail(event));
  }

  //
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
    _displayEvents.close();
    _unavailabilityEvents.close();
  }
}
