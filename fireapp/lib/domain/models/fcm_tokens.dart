import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_tokens.freezed.dart';
part 'fcm_tokens.g.dart';
@freezed
class FCMToken with _$FCMToken {
  const factory FCMToken({
    required int userId,
    @JsonKey(name: "token") required String fcmToken,
    @JsonKey(name: "device_type") String? deviceType,
    @JsonKey(name: "created_at") DateTime? creationTime,
    @JsonKey(name: "updated_at") DateTime? updateTime,
    @JsonKey(name: "is_active") int? isActive, // Consider bool if possible
  }) = _FCMToken;

  factory FCMToken.fromJson(Map<String, Object?> json) =>
      _$FCMTokenFromJson(json);
}
