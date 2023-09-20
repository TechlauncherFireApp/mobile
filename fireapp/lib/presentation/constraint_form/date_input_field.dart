import 'package:fireapp/presentation/constraint_form/base_input_field.dart';
import 'package:fireapp/presentation/constraint_form/temporal_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class DateInputField extends TemporalInputField {
  const DateInputField(
      {super.key,
      required super.controller,
      required super.label,
      required super.icon,
      required String? Function(String?)? validator});

  @override
  Widget build(BuildContext context) {
    return buildContext(
      context,
      () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: BaseInputField.initialDate,
          firstDate: BaseInputField.firstSelectableDate,
          lastDate: BaseInputField.lastSelectableDate,
        );
        if (selectedDate != null) {
          controller.text =
              DateFormat(BaseInputField.presentableDate).format(selectedDate);
        }
      },
    );
  }
}
