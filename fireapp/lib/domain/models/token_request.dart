import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'token_request.freezed.dart';
part 'token_request.g.dart';

@freezed
class TokenRequest with _$TokenRequest {

  const factory TokenRequest({
    @JsonKey(name: "email")
    required String email,
    @JsonKey(name: "password")
    required String password
  }) = _TokenRequest;

  factory TokenRequest.fromJson(Map<String, Object?> json) => _$TokenRequestFromJson(json);

}