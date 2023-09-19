import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'volunteer_information.freezed.dart';
part 'volunteer_information.g.dart';

@freezed
class VolunteerInformation with _$VolunteerInformation{

  const factory VolunteerInformation({
    required String ID,
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNo,
    required int prefHours,
    required int expYears,
    required List<Qualification> qualifications,
    required AvailabilityField availabilities,
    required List<String> possibleRoles,
  }) = _VolunteerInformation;

  factory VolunteerInformation.fromJson(Map<String, Object?> json) => _$VolunteerInformationFromJson(json);
}

@freezed
class AvailabilityField with _$AvailabilityField{

  const factory AvailabilityField({
    required List<List<double>> monday,
    required List<List<double>> tuesday,
    required List<List<double>> wednesday,
    required List<List<double>> thursday,
    required List<List<double>> friday,
    required List<List<double>> saturday,
    required List<List<double>> sunday,
  }) = _AvailabilityField;

  factory AvailabilityField.fromJson(Map<String, Object?> json) => _$AvailabilityFieldFromJson(json);
}

