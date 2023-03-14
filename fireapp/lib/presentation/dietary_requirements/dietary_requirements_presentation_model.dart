import 'package:fireapp/domain/models/dietary_requirements.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'dietary_requirements_presentation_model.freezed.dart';

@freezed
class UserDietaryRequirements with _$UserDietaryRequirements {

  const factory UserDietaryRequirements({
    required List<UserDietaryRestriction> restrictions
  }) = _UserDietaryRequirements;

}

@freezed
class UserDietaryRestriction with _$UserDietaryRestriction {

  const factory UserDietaryRestriction({
    required DietaryRestriction restriction,
    required bool checked
  }) = _UserDietaryRestriction;

}

