import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'role_response.freezed.dart';
part 'role_response.g.dart';

@freezed
class RoleResponse with _$RoleResponse {

  const factory RoleResponse({
    @JsonKey(name: "userId")
    required int userId,
    @JsonKey(name: "roleId")
    required int roleId,
  }) = _RoleResponse;

  factory RoleResponse.fromJson(Map<String, Object?> json) => _$RoleResponseFromJson(json);

}