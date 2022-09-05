import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants.dart' as constants; //API URL
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'calendar.dart';

//For testing purposes
var user = '49';

class CalendarEvents {
  final String title;
  final int eventID;
  // final DateTime date;
  // var String startTime;
  // final String endTime;
  // final bool allDayStatus;

  CalendarEvents({required this.title, required this.eventID});

  @override
  String toString() => title;
}

CalendarEvents testEvent1 = CalendarEvents(title: "event1", eventID: 1);

CalendarEvents testEvent2 = CalendarEvents(title: "event2", eventID: 2);

CalendarEvents testEvent3 = CalendarEvents(title: "event3", eventID: 3);

/*
* @Desc - Calendar Event object 
*/
class EventAlbum {
  // Properties
  final int userId;
  final int eventId;
  final String title;
  final DateTime date;
  final String start; //Start Time
  final String end; //End Time
  final int periodicity; // 0: no-repeat, 1: Daily, 2: Weekly, 3: Monthly

  // Constructor
  const EventAlbum({
    required this.userId, // Can probably remove userID - unused by calendar
    required this.eventId,
    required this.title,
    required this.start,
    required this.end,
    required this.date,
    required this.periodicity,
  });

  /*
  * @Desc - A function of EventAlbum (Events) that allows one to be created from a json file easily
  * @Param - JSON Object
  * @Return - An EventAlbum object (An event)
  */
  factory EventAlbum.fromJson(Map<String, dynamic> json) {
    DateTime tempDateTime = DateTime.parse(json['start']);
    return EventAlbum(
      userId: json['userId'],
      eventId: json['eventId'],
      title: json['title'],
      date:
          DateTime.utc(tempDateTime.year, tempDateTime.month, tempDateTime.day),
      start: DateFormat.Hm().format(DateTime.parse(json['start'])),
      end: DateFormat.Hm().format(DateTime.parse(json['end'])),
      periodicity: json['periodicity'],
    );
  }
}

/*
* @Desc - Function that converts a response body into a list of events
* @Param - response.body of an API request - specifically the one for our calendar events
* @return - A list of events 
*/
List<EventAlbum> parseEvents(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<EventAlbum>((json) => EventAlbum.fromJson(json)).toList();
}

/*
* @Desc - Turns the list of events (EventAlbum) into a Date | List(Event) Map 
that can be used by the calendar
* @Param - List of Events (EventAlbum)
* @Return - Map of Date|List(EventAlbum)
*/
Map<DateTime, List<EventAlbum>> mapEventsToDates(List<EventAlbum> eventsToMap) {
  Map<DateTime, List<EventAlbum>> tempMap = {};
  for (var element in eventsToMap) {
    if (tempMap[element.date] != null) {
      tempMap[element.date]?.add(element);
    } else {
      tempMap[element.date] = [element];
    }
  }
  return tempMap;
}

/*
* @Desc - Takes the future from EventRequest and converts it into a synchronous Date|EventList Map
* @Param - None
* @Return - Map of Date|List(EventAlbum)
*/
late Map<DateTime, List<EventAlbum>> futureEventsList = {};
void runFutureEventsList() async {
  eventRequest().then((value) {
    futureEventsList = mapEventsToDates(value);
    print(futureEventsList);
  }).catchError((error) => print("Failed: " + error));
}

/* ***** API REQUESTS FOR CALENDAR EVENTS ****** */

/*
* @Desc - API Request for retrieving all calendar events 
* @Param - None
* @return - A future (async) list of events 
*/
Future<List<EventAlbum>> eventRequest() async {
  //http.Client client
  String apiPath =
      'unavailability/showUnavailableEvent'; //Specific API path for this request
  Map<String, String> queryParameters = {
    'userId': user,
  }; //API Query parameters

  var url = Uri.https(
      constants.domain, apiPath, queryParameters); //Completed HTTPS URL

  final response = await http.get(url); //the GET Request

  //Check if request successful else print url + errorcode
  if (response.statusCode == 200) {
    print('200');
    print(url);
  } else {
    print(response.statusCode);
    print(url);
  }

  //Return the request reponse
  return compute(parseEvents, response.body);
}

/* ***** ADD NEW EVENTS TO CALENDAR ***** */

/*
* @Desc - Produces DateTime in ISO8601 which is the format used by the backend
* @Param - a time (in TimeOfDay format/object) and a date
* @Return - String of Date+Time in ISO7801 Format
*/
String convertTimeToISO8601(TimeOfDay time, DateTime date) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute)
      .toIso8601String();
}

/*
* @Desc - An API Request to create a new event
* @Param - startTime, endTime (as strings of DateTime's in ISO8601)
* @Param - String title, and periodicity which is an int
* @Return - None, set to Future<void> so await can be called
*/
Future<void> createEvent(
    String startTime, String endTime, String title, int p) async {
  //http.Client client
  String apiPath =
      'unavailability/createUnavailableEvent'; //Specific API path for this request
  Map<String, String> queryParameters = {
    'userId': user,
  }; //API Query parameters

  var url = Uri.https(
      constants.domain, apiPath, queryParameters); //Completed HTTPS URL

  final response = await http.post(url,
      body: json.encode({
        "userID": user,
        "start": startTime,
        "end": endTime,
        "title": title,
        "periodicity": p,
      })); //the POST Request, send Event to backend

  //Check if request successful else print url + errorcode
  if (response.statusCode == 200) {
    print('200');
    var tmpResponse = json.decode(response.body);
  } else {
    print(response.statusCode);
    print(url);
  }
} // Future<void> fn - when you want to use 'await fn' 
