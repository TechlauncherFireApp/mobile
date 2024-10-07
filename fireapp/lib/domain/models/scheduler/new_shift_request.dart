import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'new_shift_request.freezed.dart';
part 'new_shift_request.g.dart';

@freezed
class NewShiftRequest with _$NewShiftRequest {
  const factory NewShiftRequest({
    required String title,
    @JsonKey(name: "start") required DateTime startTime,
    @JsonKey(name: "end") required DateTime endTime,
    @JsonKey(name: "vehicle_type") required int vehicleType,
  }) = _NewShiftRequest;

  factory NewShiftRequest.fromJson(Map<String, Object?> json) => _$NewShiftRequestFromJson(json);
}
