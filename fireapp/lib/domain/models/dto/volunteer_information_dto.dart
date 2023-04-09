import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
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
    @JsonKey(name: 'Monday') required List<List<int>> monday,
    @JsonKey(name: 'Tuesday') required List<List<int>> tuesday,
    @JsonKey(name: 'Wednesday') required List<List<int>> wednesday,
    @JsonKey(name: 'Thursday') required List<List<int>> thursday,
    @JsonKey(name: 'Friday') required List<List<int>> friday,
    @JsonKey(name: 'Saturday') required List<List<int>> saturday,
    @JsonKey(name: 'Sunday') required List<List<int>> sunday,
  }) = _AvailabilityFieldDto;

  factory AvailabilityFieldDto.fromJson(Map<String, dynamic> json) => _$AvailabilityFieldDtoFromJson(json);
}

