import 'package:freezed_annotation/freezed_annotation.dart';

part 'unavailability_time.freezed.dart';
part 'unavailability_time.g.dart';

// Immutable data class representing a volunteer's 'Unavailability time.
@freezed
class UnavailabilityTime with _$UnavailabilityTime{
  const factory UnavailabilityTime({
    required int? eventId, // Only NULL when creating new instance
    required int userId,
    required String title,
    required int periodicity, //Number of days between repeating event
    required DateTime startTime,
    required DateTime endTime,
  }) = _UnavailabilityTime;

  // Factory constructor to convert 'UnavailabilityTime' JSON to object
  factory UnavailabilityTime.fromJson(Map<String, Object?> json) =>
      _$UnavailabilityTimeFromJson(json);
}
