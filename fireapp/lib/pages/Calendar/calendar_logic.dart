import 'package:flutter/foundation.dart';

import '../../constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'dart:convert';

//For testing purposes
var user = '49';

enum repeatStats { none, weekly, monthly, yearly }

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

class EventAlbum {
  final int userId;
  final int eventId;
  final String title;
  final DateTime start;
  final DateTime end;
  final int periodicity;

  const EventAlbum({
    required this.userId,
    required this.eventId,
    required this.title,
    required this.start,
    required this.end,
    required this.periodicity,
  });

  factory EventAlbum.fromJson(Map<String, dynamic> json) {
    return EventAlbum(
      userId: json['userId'],
      eventId: json['eventId'],
      title: json['title'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      periodicity: json['periodicity'],
    );
  }
}

// Function that converts a response body into a list of events
List<EventAlbum> parseEvents(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<EventAlbum>((json) => EventAlbum.fromJson(json)).toList();
}

Future<List<EventAlbum>> eventRequest() async {
  //http.Client client
  String apiPath = 'unavailability/showUnavailableEvent';
  Map<String, String> queryParameters = {
    'userId': user,
  };
  var url = Uri.https(constants.domain, apiPath, queryParameters);

  final response = await http.get(url); //client.get(url);

  if (response.statusCode == 200) {
    print('200');
    print(url);
  } else {
    print(response.statusCode);
    print(url);
  }

  return compute(parseEvents, response.body);
}
