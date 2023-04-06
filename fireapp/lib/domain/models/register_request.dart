import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'register_request.freezed.dart';
part 'register_request.g.dart';

enum Gender {
  @JsonValue("Male")
  male,
  @JsonValue("Female")
  female,
  @JsonValue("Other")
  other
}

@freezed
class RegisterRequest with _$RegisterRequest {

  const factory RegisterRequest({
    required String email,
    required String password,
    @JsonKey(name: "given_name")
    required String firstName,
    @JsonKey(name: "lastName")
    required String lastName,
    required Gender gender,
    @JsonKey(name: "phone")
    String? phoneNumber
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, Object?> json) => _$RegisterRequestFromJson(json);

}