import 'package:freezed_annotation/freezed_annotation.dart';

part 'unavailability_time.freezed.dart';
part 'unavailability_time.g.dart';

// Immutable data class representing a volunteer's 'Unavailability time.
@freezed
class UnavailabilityTime with _$UnavailabilityTime{
  const factory UnavailabilityTime({
    required int eventId,
    required int userId,
    required String title,
    required String periodicity,
    required DateTime start,
    required DateTime end,
    required bool status,
  }) = _UnavailabilityTime;

  // Factory constructor to convert 'UnavailabilityTime' JSON to object
  factory UnavailabilityTime.fromJson(Map<String, Object?> json) =>
      _$UnavailabilityTimeFromJson(json);
}