import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'volunteer_information_dto.freezed.dart';
part 'volunteer_information_dto.g.dart';

@freezed
class VolunteerInformationDto with _$VolunteerInformationDto{

  const factory VolunteerInformationDto({
    required String ID,
    required String firstName,
    required String lastName,
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
    required List<List<int>> Monday,
    required List<List<int>> Tuesday,
    required List<List<int>> Wednesday,
    required List<List<int>> Thursday,
    required List<List<int>> Friday,
    required List<List<int>> Saturday,
    required List<List<int>> Sunday,
  }) = _AvailabilityFieldDto;

  factory AvailabilityFieldDto.fromJson(Map<String, Object?> json) => _$AvailabilityFieldDtoFromJson(json);
}

