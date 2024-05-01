import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/unavailability/unavailability_time.dart';

part 'calendar_navigation.freezed.dart';
@freezed
class CalendarNavigation with _$CalendarNavigation {
<<<<<<< HEAD
  const factory CalendarNavigation.eventDetail(UnavailabilityTime event) = EditEvent;
=======
  const factory CalendarNavigation.eventDetail(int eventId) = EditEvent;
>>>>>>> Yuetian/Feature/calendar-view
}
