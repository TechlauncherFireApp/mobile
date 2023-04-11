import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {

  final TextEditingController password;
  final FormFieldValidator<String>? validator;
  final String label;

  const PasswordFormField({
    super.key,
    required this.password,
    this.validator,
    required this.label
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
      controller: widget.password,
      obscureText: textObscured,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: 'Password',
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