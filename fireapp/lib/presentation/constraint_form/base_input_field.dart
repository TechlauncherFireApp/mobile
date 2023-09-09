import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'constraint_form_view.dart';

abstract class BaseInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextStyle? style;

   static OutlineInputBorder commonInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(5.0),
      topRight: Radius.circular(5.0), // same radius circular as login_page
    ),
  );

  const BaseInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.style,
  });
}