import 'package:fireapp/domain/models/shift.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';

// Immutable data class representing an event on volunteer's calendar
@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required EventType event,
    required String displayTime,
    required DateTime displayDate,
  }) = _CalendarEvent;
}

@freezed
class EventType with _$EventType {
  const factory EventType.unavailability(UnavailabilityTime unavailability) = _Unavailability;
  const factory EventType.shift(Shift shift) = _Shift;
}
