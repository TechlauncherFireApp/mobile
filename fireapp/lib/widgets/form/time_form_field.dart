
import 'package:fireapp/widgets/form/temporal_form_field.dart';
import 'package:flutter/material.dart';

class TimeFormField extends TemporalFormField<TimeOfDay> {

  const TimeFormField({
    super.key,
    required super.currentValue,
    required super.onValueChanged,
    super.decoration,
  });

  @override
  String formatTime(BuildContext context, TimeOfDay time) {
    return time.format(context);
  }

  @override
  Future<TimeOfDay?> onTap(BuildContext context) {
    return showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
    );
  }




}