import 'package:fireapp/presentation/constraint_form/base_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SchedulerTextInputField extends BaseInputField {
  const SchedulerTextInputField(
      {super.key,
      required super.controller,
      required super.style,
      required super.label,
      required super.icon,
      required String? Function(String?)? validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.labelLarge, // using the same text theme from login_page
      decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.labelLarge,
                // using the same text theme from login_page
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon),
          labelText: label,
          border: BaseInputField.commonInputBorder),
          validator: validator,
          );
          // statements;
        }
  }
