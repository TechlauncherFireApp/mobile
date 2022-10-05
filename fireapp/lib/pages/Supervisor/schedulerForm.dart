// ignore_for_file: file_names, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

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
          ],
        ),
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
}
