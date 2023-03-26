import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'volunteer_listing.freezed.dart';
part 'volunteer_listing.g.dart';

@freezed
class VolunteerListing with _$VolunteerListing {

  const factory VolunteerListing({
    required String volunteerId,
    required String name,
  }) = _VolunteerListing;

  factory VolunteerListing.fromJson(Map<String, Object?> json) => _$VolunteerListingFromJson(json);

}