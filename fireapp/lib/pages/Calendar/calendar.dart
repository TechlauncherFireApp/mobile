// ignore_for_file: unnecessary_new

// PACKAGES
import 'package:fireapp/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//PAGES
import 'calendar_logic.dart';
import 'calendarForm.dart';

//We are using the table calendar package
/*
SPRINT 3 -TODO: 
* Event Adding Form Improvemennts
  - Event Input Form has Form Validation [DONE]
  - add "All Day toggle" which hides the time input options... [DONE]
  - Repeat events toggle (selection in form & show on calendar) [DONE]
  - calendar can handle cylical events 
* Modifying Events
  - Events now deleteable [DONE]
  - Events now clickable... [DONE]
  - Create a copy of the pre-existing form... - Maybe refactor into a widget... [DONE]
  - Opens form - prefilled with the event details [DONE]
  - Onsubmit it deletes the old one and adds a new one. [DONE]
* VISUAL
  - Event on day calendar - dif shade... [DONE]
  - Padding/Styling on input form
  - Center loading circle - currently it shows in top left corner [DONE]
  - See idea @ bottom of page...
*/

/* BUGS:
1. cards on selected day arent being built right away on addition
2. bottom overflow error when too many events on a given day
3. error message in console when removing the last event from a day [SOLVED]
4. Overflow on form w/ keyboard open...
5. Modifying form can't call a new eventRequest()  [SOLVED]
6. Floating Action Button covers the edit button for the third evennt if only three events
*/

/* CONCERNS:
1. Adjustable spacing... how will it look on bigger form factors?
*/

/* Initial Component */
class MyCalendarPage extends StatefulWidget {
  const MyCalendarPage({super.key});

  //Refactor into Calendar Page
  @override
  _MyCalendarPage createState() => _MyCalendarPage();
}

class _MyCalendarPage extends State<MyCalendarPage> {
  late Future<List<EventAlbum>> _eventData;

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
            return Column(
              children: [
                //Note: MapEventsToDates - Puts _eventData (snapshot.data) into the format of Map<DateTime, List<EventAlbum>>
                buildCalendar(mapEventsToDates(snapshot.data)),
                buildEventsList(),
              ],
            );
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

  /* Calendar SETUP */
  //Setup for stateful calendar format - default format is month, could try week?
  CalendarFormat calendarFormat = CalendarFormat.month;
  // Selected day on Calendar - set to current date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  // List of events for a selected day
  List<EventAlbum> _listOfEventsForSelectedDay = [];

  Widget calendarPage(eventData) {
    //Initialise Map of DateTime + A list of events on that Day & pull that from the API
    Map<DateTime, List<EventAlbum>> eventsDateMap = mapEventsToDates(eventData);
    //Functions for assorting events by days

    return Column(
      children: [
        buildCalendar(eventsDateMap),
        buildEventsList(),
      ],
    );
  }

// Calendar Widget
  Widget buildCalendar(Map<DateTime, List<EventAlbum>> eventsDateMap) {
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
            _listOfEventsForSelectedDay = eventsDateMap[_selectedDay] ?? [];
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay =
              focusedDay; // Prevents widget rebuild errors with focusedday - does not require setState()
        },
        // Calendar Events - see note below on how Calendar Event Handling works
        eventLoader: (DateTime day) {
          return eventsDateMap[day] ?? [];
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
    return ListView.builder(
      itemCount: _listOfEventsForSelectedDay.length,
      shrinkWrap: true,
      // Technically bad prac to have a listview inside of a col and then to shrinkwrap it, I suggest looking into an option using expanded and sizedbox instead....
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
