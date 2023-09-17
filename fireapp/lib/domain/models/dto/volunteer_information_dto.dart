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
    @JsonKey(name: "expHours")
    required int expYears,
    required List<String> qualification,
    required AvailabilityFieldDto availabilities,
    required List<String> possibleRoles,
  }) = _VolunteerInformationDto;

  factory VolunteerInformationDto.fromJson(Map<String, Object?> json) => _$VolunteerInformationDtoFromJson(json);
}


@freezed
class AvailabilityFieldDto with _$AvailabilityFieldDto{

  const factory AvailabilityFieldDto({
    @JsonKey(name: 'Monday') required List<List<double>> monday,
    @JsonKey(name: 'Tuesday') required List<List<double>> tuesday,
    @JsonKey(name: 'Wednesday') required List<List<double>> wednesday,
    @JsonKey(name: 'Thursday') required List<List<double>> thursday,
    @JsonKey(name: 'Friday') required List<List<double>> friday,
    @JsonKey(name: 'Saturday') required List<List<double>> saturday,
    @JsonKey(name: 'Sunday') required List<List<double>> sunday,
  }) = _AvailabilityFieldDto;

  factory AvailabilityFieldDto.fromJson(Map<String, dynamic> json) => _$AvailabilityFieldDtoFromJson(json);
}

