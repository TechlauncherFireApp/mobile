import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_logic.dart';

//We are using the table calendar package

/*
* Improve Styling of the Calendar
* Can add events
* Can add cyclic events - see TableCalendar Documentation 
* Backend Integration w/ existing FireApp APIs
* Change navigation method... 
* Create AppColors for a consistent app colour scheme that can be used between pages...
* Fix overflow error 
*/

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

//Event Setup - Map of DateTime + A list of events on that Day
late Map<DateTime, List<MyCalendarEvents>> eventsDateMap;

class _CalendarPageState extends State<CalendarPage> {
  //Setup for stateful calendar format - default format is month, could try week?
  CalendarFormat calendarFormat = CalendarFormat.month;

  // Selected day on Calendar - set to current date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    eventsDateMap = {
      DateTime.utc(2022, 8, 10): [testEvent3],
      DateTime.utc(2022, 8, 7): [
        testEvent1,
        testEvent2,
        testEvent2,
      ],
      DateTime.utc(2022, 8, 26): [testEvent2],
      // this is just a test event, should be blank {} or load from API
    };
    super.initState();
  } // The initial state when the widget is loaded

  List<MyCalendarEvents> _listOfEventsForSelectedDay = [];

  List<MyCalendarEvents> eventsOnDay(DateTime day) {
    return eventsDateMap[day] ?? [];
  } //Gets the list of the events from the map when you have date time

  // Core page
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Calendar')),
        body: Column(
          children: [
            //Style for calendar Border
            Card(
              margin: const EdgeInsets.all(8),
              elevation: 5.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              // THE CALENDAR
              child: TableCalendar(
                // Max day and min day the calendar can go to
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 12),
                // Set the selected day
                focusedDay: _focusedDay,
                // Setting the Calendar Format & Labels for those formats
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                  CalendarFormat.week: 'Week',
                },
                calendarFormat: calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    calendarFormat = format;
                  });
                },
                // Allows the user to select different days other than current day
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _listOfEventsForSelectedDay = eventsOnDay(selectedDay);
                    print(_listOfEventsForSelectedDay.length);
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay =
                      focusedDay; // Prevents widget rebuild errors with focusedday - does not require setState()
                },
                // Calendar Events - see note below on how Calendar Event Handling works
                eventLoader: (day) {
                  return eventsOnDay(day);
                },
                // Styling the calendar
                calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Color.fromARGB(132, 244, 67, 54),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 207, 59, 48),
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    )),
                daysOfWeekHeight: 50.0,
                rowHeight: 50.0,
                headerStyle: const HeaderStyle(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 30,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 30,
                  ),
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
            ),
            ListView.builder(
              itemCount: _listOfEventsForSelectedDay.length,
              shrinkWrap: true,
              // Technically bad prac to have a listview inside of a col and then to shrinkwrap it, I suggest looking into an option using expanded and sizedbox instead....
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                      // onTap: () {}
                      title: Text(_listOfEventsForSelectedDay[index].title)),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarFormRoute()),
              );
            }),
      );
}

// Creating a 'form' widget
class CalendarForm extends StatefulWidget {
  @override
  _CalendarFormState createState() {
    return _CalendarFormState();
  }
}

class _CalendarFormState extends State<CalendarForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter the event Title',
              labelText: 'Title',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.phone),
              hintText: 'Enter a phone number',
              labelText: 'Phone',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.calendar_today),
              hintText: 'Enter your date of birth',
              labelText: 'Dob',
            ),
          ),
          new Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: new ElevatedButton(
                child: const Text('Submit'),
                onPressed: null,
              )),
        ],
      ),
    );
  }
}

//Form Page
class CalendarFormRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Flutter Form Demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: CalendarForm(),
      ),
    );
  }
}
