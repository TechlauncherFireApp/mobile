import '../../constants.dart' as constants;
import 'package:http/http.dart' as http;

class MyCalendarEvents {
  final String title;
  final String description;

  MyCalendarEvents({required this.title, required this.description});

  @override
  String toString() => title;
}

MyCalendarEvents testEvent1 =
    MyCalendarEvents(title: "event1", description: "test");

MyCalendarEvents testEvent2 =
    MyCalendarEvents(title: "event2", description: "test?");

MyCalendarEvents testEvent3 =
    MyCalendarEvents(title: "event3", description: "test?");

class ImportCalendarEvents {}
