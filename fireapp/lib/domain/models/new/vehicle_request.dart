import 'package:freezed_annotation/freezed_annotation.dart';

// This associates 'vehicle_request.dart' with the code generated by Freezed
part 'vehicle_request.freezed.dart';
part 'vehicle_request.g.dart';

// Immutable data class representing a vehicle request.
@freezed
class VehicleRequest with _$VehicleRequest{
  const factory VehicleRequest({
    required String requestId,
    required DateTime startDate,
    required DateTime endDate,
    required String assetType,
  }) = _VehicleRequest;
  // Conversion of PostRequestInput from JSON
  factory VehicleRequest.fromJson(Map<String, Object?> json) => _$VehicleRequestFromJson(json);
}

// Immutable data class representing the vehicle list.
@freezed
class VehicleList with _$VehicleList {
  const factory VehicleList({
    required int id,
    required String type,
    required DateTime fromTime,
    required DateTime toTime,
  }) = _VehicleList;
  factory VehicleList.fromJson(Map<String, Object?> json) => _$VehicleListFromJson(json);
}

@freezed
class ResourceField with _$ResourceField {
  const factory ResourceField({
    required bool success,
    required int id,
    required String result
  }) = _ResourceField;
  factory ResourceField.fromJson(Map<String, Object?> json) => _$ResourceFieldFromJson(json);
}

