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
      body: const CalendarForm(),
    );
  }
}

// Creating a 'form' widget
class CalendarForm extends StatefulWidget {
  const CalendarForm({super.key});

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
  var repeatDropDownValue = 0;
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
          buildTitleField(),
          buildDatePicker(),
          buildStartTimeField(),
          buildEndTimeField(),
          buildEventDropDown(),
          buildSubmitButton(context, setDate, setStart, setEnd,
              titleController.text, repeatDropDownValue),
        ],
      ),
    );
  }

  //Title Text Field
  Widget buildTitleField() {
    return TextFormField(
      controller: titleController,
      decoration: const InputDecoration(
        icon: Icon(Icons.title),
        hintText: 'Enter the event Title',
        labelText: 'Title',
      ),
      validator: (v) {
        if (v!.isEmpty) {
          return 'Title is empty!';
        }
        return null;
      },
    );
  }

  Widget buildDatePicker() {
    // Date Time Picker
    return TextFormField(
      controller: inputDateController,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today),
        labelText: "Enter Date",
      ),
      readOnly: true, //So it can't be changed without using the picker
      validator: (v) {
        if (v!.isEmpty) {
          return 'Date is empty!';
        }
        return null;
      },
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
      },
    );
  }

  Widget buildStartTimeField() {
    // StartTime - Input
    return TextFormField(
      controller: startTimeController,
      decoration: const InputDecoration(
        icon: Icon(Icons.hourglass_top),
        labelText: "Enter Start Time",
      ),
      readOnly: true,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Start Time is empty!';
        }
        return null;
      },
      onTap: () async {
        TimeOfDay? newTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (newTime != null) {
          setState(() {
            startTimeController.text = newTime.format(context);
            setStart = newTime;
          });
        }
      },
    );
  }

  // End Time Input
  Widget buildEndTimeField() {
    return TextFormField(
      controller: endTimeController,
      decoration: const InputDecoration(
        icon: Icon(Icons.hourglass_bottom),
        labelText: "Enter End Time",
      ),
      readOnly: true,
      validator: (v) {
        if (v!.isEmpty) {
          return 'End Time is empty!';
        }
        return null;
      },
      onTap: () async {
        TimeOfDay? newTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (newTime != null) {
          setState(() {
            endTimeController.text = newTime.format(context);
            setEnd = newTime;
          });
        }
      },
    );
  }

  //eventDropDown
  Widget buildEventDropDown() {
    return DropdownButtonFormField(
      value: repeatDropDownValue,
      items: const [
        DropdownMenuItem(value: 0, child: Text('None')),
        DropdownMenuItem(value: 1, child: Text('Daily')),
        DropdownMenuItem(value: 2, child: Text('Weekly')),
        DropdownMenuItem(value: 3, child: Text('Monthly')),
      ],
      onChanged: (int? value) {
        setState(() {
          repeatDropDownValue = value!;
        }); // Assign selected value
        //print(repeatDropDownValue);
      },
      decoration: const InputDecoration(
          labelText: "Repeat?", icon: Icon(Icons.refresh)),
    );
  }

  // Submit Button
  Widget buildSubmitButton(BuildContext context, setDate, setStart, setEnd,
      title, repeatDropDownValue) {
    return Container(
      padding: const EdgeInsets.only(left: 150.0, top: 40.0),
      // ignore: unnecessary_new
      child: ElevatedButton(
        child: const Text('Submit'),
        // SUBMIT FUNCTION
        onPressed: () async {
          //Form Validationn --- Checks if all fields with a validate property are filled out
          if (_formKey.currentState!.validate()) {
            // Checks that end time is after start time
            if (timeToDouble(setEnd) > timeToDouble(setStart)) {
              // Calendar Widget only accepts UTC dates without any time values
              String startDate = convertTimeToISO8601(setStart, setDate);
              String endDate = convertTimeToISO8601(setEnd, setDate);

              // POST Request
              await createEvent(startDate, endDate, title, repeatDropDownValue);

              //Return to calendar page
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("End time can't be before Start time")),
              );
            }
          }
        },
      ),
    );
  }
}
