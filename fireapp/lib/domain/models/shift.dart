import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift.freezed.dart';
part 'shift.g.dart';

@freezed
class Shift with _$Shift {
  static const String STATUS_ACCEPTED = 'accepted';

  const factory Shift({
    required int shiftId,
    required String title,
    required DateTime start,
    required DateTime end,
    required String status,
  }) = _Shift;

  // Factory constructor to convert 'Shift' JSON to object
  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}
