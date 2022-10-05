// ignore_for_file: unnecessary_new

// PACKAGES
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//PAGES
import 'calendar_logic.dart';
import 'calendarForm.dart';

/* CONCERNS:
1. Adjustable spacing... how will it look on bigger form factors?
2. Floating Action Button covers the edit button for the third event if only three events
*/

/* Initial Component */
class MyCalendarPage extends StatefulWidget {
  const MyCalendarPage({super.key});

  //Refactor into Calendar Page
  @override
  _MyCalendarPage createState() => _MyCalendarPage();
}

DateTime today = DateTime.now();

class _MyCalendarPage extends State<MyCalendarPage> {
  late Future<List<EventAlbum>> _eventData;

  // List of events for a selected day
  List<EventAlbum> _listOfEventsForSelectedDay = [];

  @override
  void initState() {
    _eventData = eventRequest(); // API Request - See Calendar_Logic.dart

    super.initState();
  }

  //IF API Request returns then create calendar and parse in the data
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar - Calendar title bar
      appBar: AppBar(
          title: const Text('Calendar'), automaticallyImplyLeading: false),
      //Main Body / Future Builder
      body: FutureBuilder(
        future: _eventData, //Data from API Request
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return calendarBody(snapshot.data); // I forgot what this is?
          }
          return Container();
        },
      ),
      //Floating Action Button
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalendarFormRoute()),
          );
          setState(() {
            _eventData = eventRequest();
          });
          //Note that if using an await - usually better to await before a sync setState and then setState but ok here because using futureBuilder instead so we can use a sync (not async) setState by default
        },
      ),
    );
  }

  Widget calendarBody(List<EventAlbum> l) {
    _listOfEventsForSelectedDay = eventloading(_selectedDay, l);
    return Column(
      children: [
        buildCalendar(l),
        buildEventsList(),
      ],
    );
  }

  /* Calendar SETUP */
  //Setup for stateful calendar format - default format is month, could try week?
  CalendarFormat calendarFormat = CalendarFormat.month;
  // Selected day on Calendar - set to current date
  DateTime _focusedDay = DateTime.utc(today.year, today.month, today.day);
  DateTime _selectedDay = DateTime.utc(today.year, today.month, today.day);
  //Calendar package requires a UTC format with no hour/min information - therefore you can't just use DateTime.now()

  /*
  * @Desc - gets all the events that should be on a specific day, including repeating events
  * @Param - the day (selection), the list of events
  * @Return - A list of events (that match the selected day)
  */
  List<EventAlbum> eventloading(DateTime day, List<EventAlbum> eList) {
    List<EventAlbum> noRepeatList = [];
    List<EventAlbum> dailyList = [];
    List<EventAlbum> returnList = [];
    Map<DateTime, List<EventAlbum>> map;

    for (var e in eList) {
      if (e.periodicity == 1 &&
          (day.isAfter(e.date) || day.isAtSameMomentAs(e.date))) {
        dailyList.add(e);
      } else if (e.periodicity == 2 &&
          (day.isAfter(e.date) || day.isAtSameMomentAs(e.date))) {
        if (e.date.weekday == day.weekday) {
          returnList.add(e);
        }
      } else if (e.periodicity == 3) {
        if (e.date.day == day.day &&
            (day.isAfter(e.date) || day.isAtSameMomentAs(e.date))) {
          returnList.add(e);
        }
      } else {
        noRepeatList.add(e);
      }
    }
    map = mapEventsToDates(noRepeatList);
    returnList = returnList + dailyList + (map[day] ?? []);
    return returnList;
  }

// Calendar Widget
  Widget buildCalendar(List<EventAlbum> eventsList) {
    //_listOfEventsForSelectedDay = eventloading(_selectedDay, eventsList);
    return Card(
      //The card which the calendar sits ontop of
      margin: const EdgeInsets.all(8),
      elevation: 5.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      // THE CALENDAR ITSELF
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
            _listOfEventsForSelectedDay = eventloading(selectedDay, eventsList);
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay =
              focusedDay; // Prevents widget rebuild errors with focusedday - does not require setState()
        },
        // Calendar Events - see note below on how Calendar Event Handling works
        eventLoader: (day) {
          return eventloading(day, eventsList);
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
              color: Color.fromARGB(255, 58, 57, 57),
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
    );
  }

  Widget buildEventsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _listOfEventsForSelectedDay.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Dismissible(
            // Makes the card dismissable via a swipe
            key: ValueKey(_listOfEventsForSelectedDay[index]),
            background: Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: const Text("Remove",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            onDismissed: (direction) async {
              await removeEvent(_listOfEventsForSelectedDay[index].eventId);
              setState(() {
                _listOfEventsForSelectedDay.removeAt(index);
                _eventData = eventRequest(); // Is this inefficient???
              });
            },
            // THE INDIVIDUAL EVENT CARD
            child: Card(
              child: ListTile(
                // onTap: () {}
                title: Text(_listOfEventsForSelectedDay[index].title),
                subtitle: Row(
                  children: [
                    Text(
                      timeString(_listOfEventsForSelectedDay[index].start,
                          _listOfEventsForSelectedDay[index].end),
                    ),
                    SizedBox(width: 25),
                    repeatIcon(_listOfEventsForSelectedDay[index].periodicity),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ModifyEventFormRoute(
                              event: _listOfEventsForSelectedDay[index])),
                    );
                    setState(() {
                      _eventData = eventRequest();
                    });
                  },
                  icon: const Icon(Icons.edit_note),
                ),
                //leading:
              ),
            ),
          );
        },
      ),
    );
  }

  Widget repeatIcon(int period) {
    if (period > 0) {
      return Row(children: [
        const Icon(
          Icons.repeat,
          size: 18,
        ),
        Text(repeatAmount(period)),
      ]);
    } else {
      return const Text(" ");
    }
  }

  /* 
  * @Desc - Returns the appropriate string for event time
  * @Param - two Strings, start time and end time
  * @Return - A String that represents time an event goes for
  */
  String timeString(String startTime, String endTime) {
    if (startTime == "00:00" && endTime == "23:59") {
      return "All-Day";
    } else {
      return "$startTime - $endTime";
    }
  }

  /*
  * @Desc - A function to return the indicator letter for repeating events
  * @Param - integer representing an events periodicity
  * @Return - A single character in String format
  */
  String repeatAmount(int periodicity) {
    switch (periodicity) {
      case 1:
        return "Daily";
      case 2:
        return "Weekly";
      case 3:
        return "Monthly";
      default:
        return " ";
    } // Show periodicity using Empty, D, W, M
  }
}
