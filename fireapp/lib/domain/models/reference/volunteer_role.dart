import 'package:fireapp/domain/models/reference/reference_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'volunteer_role.freezed.dart';
part 'volunteer_role.g.dart';

@freezed
class VolunteerRole
    with _$VolunteerRole
    implements ReferenceData {

  @Implements<ReferenceData>()
  const factory VolunteerRole({
    required int id,
    required String name,
    required DateTime updated,
    required DateTime created
  }) = _VolunteerRole;

  factory VolunteerRole.fromJson(Map<String, Object?> json) => _$VolunteerRoleFromJson(json);

}