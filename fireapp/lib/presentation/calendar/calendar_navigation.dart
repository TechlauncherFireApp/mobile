import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_navigation.freezed.dart';
@freezed
class CalendarNavigation with _$CalendarNavigation {
  const factory CalendarNavigation.eventDetail(int eventId) = EditEvent;
}
