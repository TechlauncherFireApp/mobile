import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_tokens.freezed.dart';
part 'fcm_tokens.g.dart';
@freezed
class FCMTokens with _$FCMTokens {
  const factory FCMTokens({
    required int userId,
    @JsonKey(name: "token") required String fcmToken,
    @JsonKey(name: "device_type") String? deviceType,
    @JsonKey(name: "created_at") DateTime? creationTime,
    @JsonKey(name: "updated_at") DateTime? updateTime,
    @JsonKey(name: "is_active") int? isActive, // Consider bool if possible
  }) = _FCMTokens;

  factory FCMTokens.fromJson(Map<String, Object?> json) =>
      _$FCMTokensFromJson(json);
}
