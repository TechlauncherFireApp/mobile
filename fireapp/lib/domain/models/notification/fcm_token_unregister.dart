import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_token_unregister.freezed.dart';
part 'fcm_token_unregister.g.dart';
@freezed
class FCMTokenUnregister with _$FCMTokenUnregister {
  const factory FCMTokenUnregister({
    @JsonKey(name: "token") required String fcmToken,
  }) = _FCMTokenUnregister;

  factory FCMTokenUnregister.fromJson(Map<String, Object?> json) =>
      _$FCMTokenUnregisterFromJson(json);
}
