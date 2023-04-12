import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'dietary_requirements.freezed.dart';
part 'dietary_requirements.g.dart';

@freezed
class DietaryRequirements with _$DietaryRequirements {

  const factory DietaryRequirements({
    required List<DietaryRestriction> restrictions,
    @JsonKey(name: "custom_restrictions")
    required String? customRestrictions
  }) = _DietaryRequirements;

  factory DietaryRequirements.fromJson(Map<String, Object?> json) => _$DietaryRequirementsFromJson(json);

}

@freezed
class DietaryRestriction with _$DietaryRestriction {

  const factory DietaryRestriction({
    required String key,
    @JsonKey(name: "display_name")
    required String displayName
  }) = _DietaryRestriction;

  factory DietaryRestriction.fromJson(Map<String, Object?> json) => _$DietaryRestrictionFromJson(json);

}
