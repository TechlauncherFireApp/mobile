import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  static const String presentableDate = 'yyyy-MM-dd';
  static DateTime initialDate = DateTime.now();
  static DateTime firstSelectableDate = DateTime(2020);
  static DateTime lastSelectableDate = DateTime(2100);

  const BaseInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.style,
  });
}
