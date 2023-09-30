
import 'package:flutter/material.dart';

extension DateExtension on DateTime {

  DateTime withTime(TimeOfDay timeOfDay) {
    return DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute, 0);
  }

}