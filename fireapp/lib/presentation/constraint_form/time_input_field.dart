import 'package:fireapp/presentation/constraint_form/temporal_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SchedulerTimeInputField extends TemporalInputField {
  const SchedulerTimeInputField(
      {super.key, required super.controller,
      required super.label,
      required super.icon,
      required String? Function(String?)? validator});

  @override
  Widget build(BuildContext context) {
    return buildContext(context, () async {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        controller.text = selectedTime.format(context);
      }
    },
    );
  }
}
