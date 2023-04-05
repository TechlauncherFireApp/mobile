import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'volunteer_information_dto.freezed.dart';
part 'volunteer_information_dto.g.dart';

@freezed
class VolunteerInformationDto with _$VolunteerInformationDto{

  const factory VolunteerInformationDto({
    required String volunteerId,
    required String name,
    required String email,
    required String mobileNo,
    required int prefHours,
    required int expYears,
    required List<String> qualifications,
    required AvailabilityFieldDto availabilities,
    required List<String> possibleRoles,
  }) = _VolunteerInformationDto;

  factory VolunteerInformationDto.fromJson(Map<String, Object?> json) => _$VolunteerInformationDtoFromJson(json);
}

@freezed
class AvailabilityFieldDto with _$AvailabilityFieldDto{

  const factory AvailabilityFieldDto({
    required List<List<int>> monday,
    required List<List<int>> tuesday,
    required List<List<int>> wednesday,
    required List<List<int>> thursday,
    required List<List<int>> friday,
    required List<List<int>> saturday,
    required List<List<int>> sunday,
  }) = _AvailabilityFieldDto;

  factory AvailabilityFieldDto.fromJson(Map<String, Object?> json) => _$AvailabilityFieldDtoFromJson(json);
}

