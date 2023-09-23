
import 'package:fireapp/base/date_contants.dart';
import 'package:fireapp/widgets/form/temporal_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormField extends TemporalFormField<DateTime> {

  final DateTime? firstSelectableDate;
  final DateTime? lastSelectableDate;
  final DateTime? initialDate;
  final String dateFormat;

  const DateFormField({
    super.key,
    required super.currentValue,
    required super.onValueChanged,
    super.decoration,
    this.firstSelectableDate,
    this.lastSelectableDate,
    this.initialDate,
    this.dateFormat = presentableDate
  });

  @override
  String formatTime(BuildContext context, DateTime time) {
    return DateFormat(dateFormat).format(time);
  }

  @override
  Future<DateTime?> onTap(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: initialDate ?? globalInitialDate,
        firstDate: firstSelectableDate ?? globalFirstSelectableDate,
        lastDate: lastSelectableDate ?? globalLastSelectableDate
    );
  }

}