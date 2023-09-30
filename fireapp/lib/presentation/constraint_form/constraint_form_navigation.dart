
import 'package:freezed_annotation/freezed_annotation.dart';

part 'constraint_form_navigation.freezed.dart';

@freezed
class ConstraintFormNavigation with _$ConstraintFormNavigation {
  const factory ConstraintFormNavigation.shiftRequest(String requestId) = ShiftRequest;
}