import 'package:freezed_annotation/freezed_annotation.dart';

part 'unavailability_event_post.freezed.dart';
part 'unavailability_event_post.g.dart';

// Immutable data class of a volunteer's request to create unavailable event
@freezed
class UnavailabilityEventPost with _$UnavailabilityEventPost {
  const factory UnavailabilityEventPost({
    required String title,
    required DateTime start,
    required DateTime end,
    required int periodicity, //Number of days between repeating events
    @Default(false) bool isShift,
  }) = _UnavailabilityEventPost;

  // Factory constructor to convert 'UnavailabilityTime' JSON to object
  factory UnavailabilityEventPost.fromJson(Map<String, Object?> json) =>
      _$UnavailabilityEventPostFromJson(json);
}
