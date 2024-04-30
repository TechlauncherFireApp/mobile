import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';

// Immutable data class representing an event on volunteer's calendar
@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required UnavailabilityTime event,
    required String displayTime,
    required DateTime startTime,
    required DateTime endTime,
  }) = _CalendarEvent;

}
