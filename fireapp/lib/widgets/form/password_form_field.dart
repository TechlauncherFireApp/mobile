import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {

  final InputDecoration? decoration;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String? label;

  const PasswordFormField({
    super.key,
    this.decoration,
    required this.controller,
    this.validator,
    this.label
  });

  @override
  State createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends FireAppState<PasswordFormField> {

  var textObscured = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: textObscured,
      validator: widget.validator,
      decoration: (widget.decoration ?? const InputDecoration()).copyWith(
        labelText: widget.label,
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                textObscured = !textObscured;
              });
            },
            icon: textObscured
                ? const Icon(Icons.remove_red_eye_outlined)
                : const Icon(Icons.remove_red_eye),
            splashRadius: 20
        ),
      )
    );
  }

}