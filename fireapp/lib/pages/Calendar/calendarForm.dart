// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_typing_uninitialized_variables, file_names
import 'package:fireapp/pages/Calendar/calendar_logic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Default Form Page - For adding an event
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

//Modify an Event Form Page
class ModifyEventFormRoute extends StatelessWidget {
  final EventAlbum event;
  const ModifyEventFormRoute({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Event'),
      ),
      body: CalendarForm(eventBasis: event),
    );
  }
}

// Creating a 'form' widget
class CalendarForm extends StatefulWidget {
  final eventBasis;
  const CalendarForm({
    super.key,
    this.eventBasis,
  });

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
  bool allDayChecked = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController inputDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  @override
  void initState() {
    //For modifying events - prefill out form with event details
    if (widget.eventBasis != null) {
      setDate = widget.eventBasis.date;
      setStart = TimeOfDay(
          hour: int.parse(widget.eventBasis.start.split(":")[0]),
          minute: int.parse(widget.eventBasis.start.split(":")[1]));
      setEnd = TimeOfDay(
          hour: int.parse(widget.eventBasis.end.split(":")[0]),
          minute: int.parse(widget.eventBasis.end.split(":")[1]));
      repeatDropDownValue = widget.eventBasis.periodicity;
      titleController.text = widget.eventBasis.title;
      if (widget.eventBasis.start == "00:00" &&
          widget.eventBasis.end == "23:59") {
        allDayChecked = true;
      } else {
        startTimeController.text = widget.eventBasis.start;
        endTimeController.text = widget.eventBasis.end;
      }
      inputDateController.text = DateFormat('yyyy-MM-dd').format(setDate);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    // MODIFY EVENT FORM - IN THE IF STATEMENT
    if (widget.eventBasis != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildTitleField(),
              buildDatePicker(),
              //Visbility widget allows the hidden status of fields to be toggled - auto handles turning off valudation
              Visibility(visible: !allDayChecked, child: buildStartTimeField()),
              Visibility(visible: !allDayChecked, child: buildEndTimeField()),
              buildAllDayCheckbox(),
              buildEventDropDown(),
              buildSubmitButton(context,
                  modifySubmitFunction), // Change to modifySubmitFunction
              buildDeleteButton(context),
            ],
          ),
        ),
      );
    }
    // ADD EVENT FORM - BELOW
    else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildTitleField(),
              buildDatePicker(),
              //Visbility widget allows the hidden status of fields to be toggled - auto handles turning off valudation
              Visibility(visible: !allDayChecked, child: buildStartTimeField()),
              Visibility(visible: !allDayChecked, child: buildEndTimeField()),
              buildAllDayCheckbox(),
              buildEventDropDown(),
              buildSubmitButton(context, defaultSubmitFunction),
            ],
          ),
        ),
      );
    }
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

  //All Day Checkbox
  Widget buildAllDayCheckbox() {
    return CheckboxListTile(
      title: const Text("All Day?"),
      controlAffinity: ListTileControlAffinity
          .leading, //Where to place it relative to the text/label
      value: allDayChecked,
      onChanged: (bool? _allDayChecked) {
        setState(() {
          allDayChecked = _allDayChecked!;
        });
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
      },
      decoration: const InputDecoration(
          labelText: "Repeat?", icon: Icon(Icons.refresh)),
    );
  }

  // Submit Button
  Widget buildSubmitButton(BuildContext context, Function fn) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 40.0),
        // ignore: unnecessary_new
        child: ElevatedButton(
          child: const Text('Submit'),
          // SUBMIT FUNCTION
          onPressed: () async {
            fn();
          },
        ),
      ),
    );
  }

  /* Submit Function
  *  DESC: validates form, converts datetime format, sends request to server, and navigates back to calendar page
  */
  void defaultSubmitFunction() async {
    //Form Validationn --- Checks if all fields with a validate property are filled out
    if (_formKey.currentState!.validate()) {
      // Checks that end time is after start time
      if (allDayChecked) {
        //If all day is checked then pass event as 12AM - 12PM
        String startDate =
            convertTimeToISO8601(const TimeOfDay(hour: 0, minute: 0), setDate);
        String endDate = convertTimeToISO8601(
            const TimeOfDay(hour: 23, minute: 59), setDate);

        // POST REQUEST
        await createEvent(
            startDate, endDate, titleController.text, repeatDropDownValue);

        //Return to calendar page
        Navigator.pop(context);
      } else {
        if (timeToDouble(setEnd) > timeToDouble(setStart)) {
          // Calendar Widget only accepts UTC dates without any time values
          // If all day not checked then parse date w/ selected time values
          String startDate = convertTimeToISO8601(setStart, setDate);
          String endDate = convertTimeToISO8601(setEnd, setDate);

          // POST REQUEST
          await createEvent(
              startDate, endDate, titleController.text, repeatDropDownValue);

          //Return to calendar page
          Navigator.pop(context);

          // Check if allday is checked...
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("End time can't be before Start time")),
          );
        }
      }
    }
  }

  /* Modify Function
  *  DESC: validates form, converts datetime format, 
  *  Deletes old event, adds new event,
  * , and navigates back to calendar page
  */
  void modifySubmitFunction() async {
    //Form Validationn --- Checks if all fields with a validate property are filled out
    if (_formKey.currentState!.validate()) {
      // Checks that end time is after start time
      if (allDayChecked) {
        //If all day is checked then pass event as 12AM - 12PM
        String startDate =
            convertTimeToISO8601(const TimeOfDay(hour: 0, minute: 0), setDate);
        String endDate = convertTimeToISO8601(
            const TimeOfDay(hour: 23, minute: 59), setDate);

        //Remove old event ... then add new one
        await removeEvent(widget.eventBasis.eventId);

        await createEvent(
            startDate, endDate, titleController.text, repeatDropDownValue);

        //Return to calendar page
        Navigator.pop(context);
      } else {
        if (timeToDouble(setEnd) > timeToDouble(setStart)) {
          // Calendar Widget only accepts UTC dates without any time values
          // If all day not checked then parse date w/ selected time values
          String startDate = convertTimeToISO8601(setStart, setDate);
          String endDate = convertTimeToISO8601(setEnd, setDate);

          //Remove old event ... then add new one
          await removeEvent(widget.eventBasis.eventId);

          await createEvent(
              startDate, endDate, titleController.text, repeatDropDownValue);

          //Return to calendar page
          Navigator.pop(context);

          // Check if allday is checked...
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("End time can't be before Start time")),
          );
        }
      }
    }
  }

  // Delete the event button
  Widget buildDeleteButton(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 25.0),
        // ignore: unnecessary_new
        child: ElevatedButton(
          child: const Text('Delete '),
          // SUBMIT FUNCTION
          onPressed: () async {
            await removeEvent(widget.eventBasis.eventId);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
