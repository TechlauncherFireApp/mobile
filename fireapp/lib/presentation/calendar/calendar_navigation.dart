import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_navigation.freezed.dart';
@freezed
class CalendarNavigation with _$CalendarNavigation {
  const factory CalendarNavigation.eventDetail(UnavailabilityTime event) = EditEvent;
}
