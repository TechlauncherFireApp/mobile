import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';

part 'change_qualification_option_model.freezed.dart';

@freezed
class UserQualifications with _$UserQualifications {

  const factory UserQualifications({
    required List<UserQualification> volunteerQualifications
  }) = _UserQualifications;

}

@freezed
class UserQualification with _$UserQualification {

  const factory UserQualification({
    required Qualification qualification,
    required bool checked,
  }) = _UserQualification;

}