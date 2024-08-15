import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift.freezed.dart';

// Immutable data class representing a shift on volunteer's schedule
@freezed
class Shift with _$Shift {
  const factory Shift({
    //TODO shift data structure fields
    required int shiftId,
    required DateTime startTime,
    required DateTime endTime,
  }) = _Shift;

}