import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_token.freezed.dart';
part 'fcm_token.g.dart';
@freezed
class FCMToken with _$FCMToken {
  const factory FCMToken({
    @JsonKey(name: "token") required String fcmToken,
    @JsonKey(name: "device_type") required String deviceType,
  }) = _FCMToken;

  factory FCMToken.fromJson(Map<String, Object?> json) =>
      _$FCMTokenFromJson(json);
}
