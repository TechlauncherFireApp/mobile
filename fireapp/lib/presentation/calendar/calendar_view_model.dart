import 'dart:async';
import 'dart:ui';

import 'package:fireapp/domain/models/calendar_event.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/repository/shifts_repository.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:fireapp/style/colors.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/models/shift.dart';
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
  late final ShiftsRepository _shiftsRepository;

  final BehaviorSubject<int> selectedMonth =
      BehaviorSubject.seeded(DateTime.now().month);

  final BehaviorSubject<int> selectedYear =
      BehaviorSubject.seeded(DateTime.now().year);

  // List of Volunteer's unavailability events
  final BehaviorSubject<RequestState<List<UnavailabilityTime>>>
      _unavailabilityEvents = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<List<UnavailabilityTime>>> get eventsStream =>
      _unavailabilityEvents.stream;

  final BehaviorSubject<RequestState<List<Shift>>> _shifts =
  BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<List<Shift>>> get shiftsStream => _shifts.stream;

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

  final List<Color> colorPalette = calendarEventColourPalette;
  int _nextColorIndex = 0;

  final Map<String, Color> eventColorMap = {};
  // Map a colour for the corresponding event
  Color? getColorForEvent(String eventId) {
    if (!eventColorMap.containsKey(eventId)) {
      eventColorMap[eventId] = colorPalette[_nextColorIndex];
      _nextColorIndex = (_nextColorIndex + 1) % colorPalette.length;
    }
    return eventColorMap[eventId];
  }

  CalendarViewModel(
      this._authenticationRepository, this._unavailabilityRepository, this._shiftsRepository);

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
  
  Future<void> fetchShifts() async {
    _loadingState.add(RequestState.loading());
    try {
      var userId = (await _authenticationRepository.getCurrentSession())?.userId;
      if (userId == null) {
        throw Exception(
            'User ID is null. Cannot update roles without a valid user ID.');
      }
      var shifts = await _shiftsRepository.getVolunteerShifts(userId);
      if (shifts.isEmpty) {
        shifts = [];
      }

      _shifts.add(RequestState.success(shifts));
    } catch (e, stacktrace) {
      logger.e(e, stackTrace: stacktrace);
      _shifts.add(RequestState.exception(e));
    }
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
          DateTime(selectedYear.value, selectedMonth.value, 1);
      DateTime firstDayOfNextMonth =
          DateTime(selectedYear.value, selectedMonth.value + 1, 1);
      final selectedEndTime =
          firstDayOfNextMonth.subtract(const Duration(days: 1));
      return doPeriodsOverlap(unavailability.startTime, unavailability.endTime,
          selectedStartTime, selectedEndTime);
    }).toList();
    return filteredList;
  }

  List<Shift> filterShifts(List<Shift> shiftsList) {
    final filteredList = shiftsList.where((shift) {
      final selectedStartTime =
        DateTime(selectedYear.value, selectedMonth.value, 1);
      DateTime firstDayOfNextMonth =
        DateTime(selectedYear.value, selectedMonth.value + 1, 1);
      final selectedEndTime =
        firstDayOfNextMonth.subtract(const Duration(days: 1));
      return doPeriodsOverlap(shift.start, shift.end,
          selectedStartTime, selectedEndTime);
    }).toList();
    return filteredList;
  }

  Future<void> loadAndSetDisplayEvents() async {
    _loadingState.add(RequestState.loading());
    await Future.wait([fetchUnavailabilityEvents(), fetchShifts()]);

    final unavailabilityState = _unavailabilityEvents.value;
    final shiftsState = _shifts.value;

    if (unavailabilityState is SuccessRequestState<List<UnavailabilityTime>> &&
        shiftsState is SuccessRequestState<List<Shift>>) {
      final unavailabilityList = unavailabilityState.result;
      final shiftsList = shiftsState.result;

      var filteredUnavailability = filterEvents(unavailabilityList);
      var filteredShifts = filterShifts(shiftsList);

      _displayEvents.add(mapToCalendarEvents(filteredUnavailability, filteredShifts));
    } else {
      _displayEvents.add([]);
    }

    _loadingState.add(RequestState.success(null));
  }

  // Convert list of unavailability events to displayable calendar events
  List<CalendarEvent> mapToCalendarEvents(List<UnavailabilityTime> unavailability, List<Shift> shifts) {
    List<CalendarEvent> displayEventList = [];
    for (var event in [...unavailability, ...shifts]) {
      final firstDayOfMonth =
          DateTime(selectedYear.value, selectedMonth.value, 1);
      //Fix start date
      final startDate;
      if (event is Shift) {
        startDate = (event.start.isBefore(firstDayOfMonth) && !isSameDay(event.start, firstDayOfMonth))
            ? firstDayOfMonth
            : event.start;
      } else if (event is UnavailabilityTime) {
        startDate = (event.startTime.isBefore(firstDayOfMonth) && !isSameDay(event.startTime, firstDayOfMonth))
            ? firstDayOfMonth
            : event.startTime;
      } else {
        startDate = firstDayOfMonth;
      }

      DateTime firstDayOfNextMonth =
          DateTime(selectedYear.value, selectedMonth.value + 1, 1, 23, 59);
      final lastDayOfMonth =
          firstDayOfNextMonth.subtract(const Duration(days: 1));
      //Fix end date
      final endDate;
      if (event is Shift) {
        endDate = (event.end.isAfter(lastDayOfMonth) && !isSameDay(event.end, lastDayOfMonth))
            ? lastDayOfMonth
            : event.end;
      } else if (event is UnavailabilityTime) {
        endDate = (event.endTime.isAfter(lastDayOfMonth) && !isSameDay(event.endTime, lastDayOfMonth))
            ? lastDayOfMonth
            : event.endTime;
      } else {
        endDate = firstDayOfNextMonth;
      }

      final numDays = endDate.difference(startDate).inDays;
      // For each day in the event
      for (int i = 0; i <= numDays; i++) {
        var currentDate = startDate;
        currentDate = currentDate.add(Duration(days: i));
        String displayTimeLabel =
            getDisplayTimeLabel(i, numDays, startDate, endDate);
        displayEventList.add(CalendarEvent(
            event: event is Shift ? EventType.shift(event) : EventType.unavailability(event as UnavailabilityTime),
            displayTime: displayTimeLabel,
            displayDate: currentDate));
      }
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
    else if (i == 0 && numDays > 0) {
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

        if (userID == null) {
          throw Exception(
              'User ID is null. Cannot update without a valid user ID.');
        }
        await _unavailabilityRepository.deleteUnavailabilityEvent(
            userID, eventID);

        // Remove the deleted event from the display events
        _displayEvents.add(_displayEvents.value.where((calendarEvent) {
          return calendarEvent.event.when(
            unavailability: (unavailabilityTime) => unavailabilityTime.eventId != eventID,
            shift: (_) => true, // Keep all shifts
          );
        }).toList());

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
    selectedMonth.value = month;
  }

  void updateSelectedYear(int year) {
    if (year < 0) {
      return;
    }
    selectedYear.value = year;
  }

  @override
  Future<void> dispose() async {
    selectedMonth.close();
    selectedYear.close();
    _navigate.close();
    _loadingState.close();
    _displayEvents.close();
    _unavailabilityEvents.close();
  }
}
