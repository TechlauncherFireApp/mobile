import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'constraint_form.dart';

class BaseInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextStyle? style;
  final schedulerInputType inputType;

  const BaseInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.style,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    switch (inputType) {
      case schedulerInputType.text:
        {
          return TextFormField(
            controller: controller,
            style: Theme.of(context)
                .textTheme
                .labelLarge, // using the same text theme from login_page
            decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.labelLarge,
                // using the same text theme from login_page
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(icon),
                labelText: label,
                border: commonInputBorder),
            validator: validator,
          );
          // statements;
        }
      case schedulerInputType.date:
        {
          return TextFormField(
            controller: controller,
            style: Theme.of(context).textTheme.labelLarge,
            // using the same text theme from login_page
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)?.enterDate,
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.calendar_today),
              border: commonInputBorder,
            ),
            readOnly: true,
            validator: validator,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
              }
            },
          );
        }
      case schedulerInputType.time:
        {
          return TextFormField(
            controller: controller,
            style: style ?? Theme.of(context).textTheme.labelLarge,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)?.enterStartTime,
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(icon),
              border: commonInputBorder,
            ),
            readOnly: true,
            validator: validator,
            onTap: () async {
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (selectedTime != null) {
                controller.text = selectedTime.format(context);
              }
            },
          );
          //statements;
        }
    }
  }
}
