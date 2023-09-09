
import 'package:fireapp/presentation/constraint_form/temporal_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class SchedulerDateInputField extends TemporalInputField {
  const SchedulerDateInputField(
      {super.key,
      required super.controller,
      required super.label,
      required super.icon,
      required String? Function(String?)? validator});

  @override
  Widget build(BuildContext context) {
    return buildContext(context, () async {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (selectedDate != null) {
        controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      }
    },
    );
  }
}
