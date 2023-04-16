
import 'package:fireapp/widgets/form/validators/validator.dart';
import 'package:flutter/src/widgets/form.dart';

class ListValidator<T> extends Validator<T> {

  final List<Validator<T>> validators;

  ListValidator(this.validators);

  @override
  FormFieldValidator<T> get formFieldValidator => (T? value) {
    return validators
        .map((e) => e.formFieldValidator(value))
        .firstWhere((e) => e != null, orElse: () => null);
  };

}