import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'token_response.freezed.dart';
part 'token_response.g.dart';

@freezed
class TokenResponse with _$TokenResponse {

  const factory TokenResponse({
    @JsonKey(name: "id")
    required int userId,
    @JsonKey(name: "access_token")
    required String accessToken,
    @JsonKey(name: "role")
    required String? role,
  }) = _TokenResponse;

  factory TokenResponse.fromJson(Map<String, Object?> json) => _$TokenResponseFromJson(json);

}