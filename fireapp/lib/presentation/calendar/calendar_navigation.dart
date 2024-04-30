import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/unavailability/unavailability_time.dart';

part 'calendar_navigation.freezed.dart';
@freezed
class CalendarNavigation with _$CalendarNavigation {
  const factory CalendarNavigation.eventDetail(UnavailabilityTime event) = EditEvent;
}
