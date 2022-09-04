// ignore_for_file: unnecessary_new

// PACKAGES
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

//PAGES
import 'calendar_logic.dart';
import 'calendarForm.dart';

//We are using the table calendar package

/*
SPRINT 2 - TODO: What's left...
* Connect with API 
  - Half Complete
* Events show start and end time (or all day...)

SPRINT 3 - TODO: 
* General Calendar Events Styling & Improvements
  - Fix overflow error with scrolling with too many events
* Events now clickable... 
  - Bottom tray w/ edit/remove functionality 
* Event Adding Form Improvemennts
  - Event Input Form has Form Validation 
  - add "All Day toggle" which hides the time input options... 
  - Repeat events toggle (selection) + show on calendar (see tablecalendar documentation for cylic events)
  - Styling of input form - see Material 3 guidelines for TimeInputPicker, + spacing, theming, etc
*/

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  //Setup for stateful calendar format - default format is month, could try week?
  CalendarFormat calendarFormat = CalendarFormat.month;

  //Event Setup - Map of DateTime + A list of events on that Day
  //late Map<DateTime, List<CalendarEvents>> eventsDateMap;
  late Map<DateTime, List<EventAlbum>> eventsDateMap;

  // Selected day on Calendar - set to current date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    runFutureEventsList();
    eventsDateMap = futureEventsList;
    print(eventsDateMap);

    super.initState();
  } // The initial state when the widget is loaded

  @override
  void dispose() {
    super.dispose();
  }

  List<EventAlbum> _listOfEventsForSelectedDay = [];

  List<EventAlbum> eventsOnDay(DateTime day) {
    return eventsDateMap[day] ?? [];
  } //Gets the list of the events from the map when you have date time

  // Core page
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Calendar'), automaticallyImplyLeading: false),
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
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay =
                      focusedDay; // Prevents widget rebuild errors with focusedday - does not require setState()
                },
                // Calendar Events - see note below on how Calendar Event Handling works
                eventLoader: eventsOnDay,
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
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarFormRoute()),
              );
              setState(() {
                if (eventsDateMap[result.resultDate] != null) {
                  eventsDateMap[result.resultDate]?.add(result.resultEvent);
                } else {
                  eventsDateMap[result.resultDate] = [result.resultEvent];
                }
              });
            }),
      );
}
