import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'shift_request.freezed.dart';
part 'shift_request.g.dart';

@freezed
class ShiftRequest with _$ShiftRequest{

  const factory ShiftRequest({
    required String shiftID,
    required String assetClass,
    required DateTime startTime,
    required DateTime endTime,
    required List<ShiftVolunteer> shiftVolunteers,
  }) = _ShiftRequest;

  factory ShiftRequest.fromJson(Map<String, Object?> json) => _$ShiftRequestFromJson(json);
}

@freezed
class ShiftVolunteer with _$ShiftVolunteer {

  const factory ShiftVolunteer({
    required int volunteerId,
    required String volunteerGivenName,
    required String volunteerSurname,
    @JsonKey(name: "mobile_number")
    required String mobileNumber,
    required int positionId,
    required String role,
    required String status,
  }) = _ShiftVolunteer;

  factory ShiftVolunteer.fromJson(Map<String, Object?> json) => _$ShiftVolunteerFromJson(json);
}
