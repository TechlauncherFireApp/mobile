import 'package:fireapp/presentation/constraint_form/base_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class TemporalInputField extends BaseInputField {
  const TemporalInputField(
      {super.key,
      required super.controller,
      required super.label,
      required super.icon});

  TextFormField buildContext(BuildContext context, void Function() onTap) {
    return TextFormField(
        controller: controller,
        style: Theme.of(context).textTheme.labelLarge,
        // using the same text theme from login_page
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)?.enterDate,
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(Icons.calendar_today),
          border: BaseInputField.commonInputBorder,
        ),
        readOnly: true,
        validator: validator,
        onTap: onTap);
  }
}
