import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'volunteer_listing.freezed.dart';
part 'volunteer_listing.g.dart';

@freezed
class VolunteerListing with _$VolunteerListing {

  const VolunteerListing._();

  const factory VolunteerListing({
    @JsonKey(name: "ID")
    required String volunteerId,
    required String firstName,
    required String lastName,
    required List<String> qualification,
  }) = _VolunteerListing;

  String get name => "$firstName $lastName";
  String get qualifications => qualification.join(", ");

  factory VolunteerListing.fromJson(Map<String, Object?> json) => _$VolunteerListingFromJson(json);

}