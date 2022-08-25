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
