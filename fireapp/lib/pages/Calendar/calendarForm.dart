import 'package:fireapp/pages/Calendar/calendar_logic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Form Page
class CalendarFormRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Unavailability'),
      ),
      body: CalendarForm(),
    );
  }
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

  var setDate;
  var setStart;
  var setEnd;
  TextEditingController titleController = TextEditingController();
  TextEditingController inputDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter the event Title',
              labelText: 'Title',
            ),
          ),
          // Date Time Picker
          TextField(
              controller: inputDateController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Enter Date",
              ),
              readOnly: true, //So it can't be changed without using the picker
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                // If input is not dull
                if (selectedDate != null) {
                  setState(() {
                    inputDateController.text =
                        DateFormat('yyyy-MM-dd').format(selectedDate);
                    setDate = selectedDate;
                  });
                }
              }),
          // StartTime - Input
          TextField(
              controller: startTimeController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Enter Time",
              ),
              readOnly: true,
              onTap: () async {
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (newTime != null) {
                  setState(() {
                    startTimeController.text = newTime.toString();
                    setStart = newTime;
                  });
                }
              }),
          // End Time Input
          TextField(
              controller: endTimeController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Enter Time",
              ),
              readOnly: true,
              onTap: () async {
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (newTime != null) {
                  setState(() {
                    endTimeController.text = newTime.toString();
                    setEnd = newTime;
                  });
                }
              }),
          // Submit Button
          Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              // ignore: unnecessary_new
              child: ElevatedButton(
                child: const Text('Submit'),
                // SUBMIT FUNCTION
                onPressed: () {
                  // Calendar Widget only accepts UTC dates without any time values
                  String startDate = convertTimeToISO8601(setStart, setDate);
                  String endDate = convertTimeToISO8601(setEnd, setDate);

                  // POST Request
                  createEvent(startDate, endDate, titleController.text, 0);

                  //Clear Controllers
                  titleController.clear();
                  inputDateController.clear();
                  startTimeController.clear();
                  endTimeController.clear();

                  //Return to calendar page
                  Navigator.pop(context);
                  // Navigator.pop(context, calendarResult);
                },
              )),
        ],
      ),
    );
  }
}
