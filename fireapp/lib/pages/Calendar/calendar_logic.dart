import '../../constants.dart' as constants;
import 'package:http/http.dart' as http;

//For testing purposes
var user = 49;

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

/*
Future<List<CalendarEvents>> eventRequest() async {
    var url = Uri.https(constants.domain, 'unavailability/showUnavailableEvent?userId='+user);
    try {
        var response = await http.post(url);
        List<CalendarEvents> tempList = []; 
        response.forEach((element) {
            tempList.add(CalendarEvent(eventID: element.eventID, title: element.title)); 
        });
        return tempList;
    }
    catch (_) {
        print('failure');
        return;
    }
}
*/
