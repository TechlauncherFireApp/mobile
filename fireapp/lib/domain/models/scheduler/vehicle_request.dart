import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'vehicle_request.freezed.dart';
part 'vehicle_request.g.dart';

@freezed
class VehicleRequest with _$VehicleRequest {

  const factory VehicleRequest({
    required String requestID,
    required DateTime startDate,
    required DateTime endDate,
    required String assetType,
  }) = _VehicleRequest;

  factory VehicleRequest.fromJson(Map<String, Object?> json) => _$VehicleRequestFromJson(json);

}