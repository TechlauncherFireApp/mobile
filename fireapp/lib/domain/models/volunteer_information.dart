import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

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
    List<List<int>>? Monday,
    List<List<int>>? Tuesday,
    List<List<int>>? Wednesday,
    List<List<int>>? Thursday,
    List<List<int>>? Friday,
    List<List<int>>? Saturday,
    List<List<int>>? Sunday,
  }) = _AvailabilityField;

  factory AvailabilityField.fromJson(Map<String, Object?> json) => _$AvailabilityFieldFromJson(json);
}

