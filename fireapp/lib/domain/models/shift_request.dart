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
    required List<Volunteer> volunteers,
  }) = _ShiftRequest;

  factory ShiftRequest.fromJson(Map<String, Object?> json) => _$ShiftRequestFromJson(json);
}

@freezed
class Volunteer with _$Volunteer {

  const factory Volunteer({
    required int volunteerId,
    required String volunteerGivenName,
    required String volunteerSurname,
    required String mobileNumber,
    required int positionId,
    required String role,
    required String status,
  }) = _Volunteer;

  factory Volunteer.fromJson(Map<String, Object?> json) => _$VolunteerFromJson(json);
}
