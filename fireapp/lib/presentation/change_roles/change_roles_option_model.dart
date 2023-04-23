import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:fireapp/domain/models/reference/volunteer_role.dart';

part 'change_roles_option_model.freezed.dart';

@freezed
class UserRoles with _$UserRoles {

  const factory UserRoles({
    required List<UserRole> volunteerRoles
  }) = _UserRoles;

}

@freezed
class UserRole with _$UserRole {

  const factory UserRole({
    required VolunteerRole role,
    required bool checked,
  }) = _UserRole;

}