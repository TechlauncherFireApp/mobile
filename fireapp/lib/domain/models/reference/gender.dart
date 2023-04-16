import 'package:freezed_annotation/freezed_annotation.dart';

part 'gender.freezed.dart';

enum Gender {
  @JsonValue("Male")
  male,
  @JsonValue("Female")
  female,
  @JsonValue("Other")
  other
}

@freezed
class GenderOption with _$GenderOption {

  const factory GenderOption({
    required String label,
    required Gender gender,
  }) = _GenderOption;

  static List<GenderOption> genders = [
    const GenderOption(label: "Male", gender: Gender.male),
    const GenderOption(label: "Female", gender: Gender.female),
    const GenderOption(label: "Other", gender: Gender.other),
  ];

}