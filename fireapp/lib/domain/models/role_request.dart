import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'role_request.freezed.dart';
part 'role_request.g.dart';

@freezed
class RoleRequest with _$RoleRequest {

  const factory RoleRequest({
    @JsonKey(name: "userId")
    required int userId,
    @JsonKey(name: "roleId")
    required int roleId,
  }) = _RoleRequest;

  factory RoleRequest.fromJson(Map<String, Object?> json) => _$RoleRequestFromJson(json);

}