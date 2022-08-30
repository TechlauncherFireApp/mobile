import '../../constants.dart' as constants;
import 'package:http/http.dart' as http;

class CalendarEvents {
  final String title;
  final String description;

  CalendarEvents({required this.title, required this.description});

  @override
  String toString() => title;
}

CalendarEvents testEvent1 =
    CalendarEvents(title: "event1", description: "test");

CalendarEvents testEvent2 =
    CalendarEvents(title: "event2", description: "test?");

CalendarEvents testEvent3 =
    CalendarEvents(title: "event3", description: "test?");

class ImportCalendarEvents {}
