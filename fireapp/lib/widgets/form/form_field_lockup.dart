
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormFieldLockup extends StatelessWidget {
  
  final String title;
  final String? subtitle;
  final bool optional;
  final Widget child;
  
  const FormFieldLockup({
    super.key, 
    required this.title, 
    this.subtitle, 
    this.optional = false, 
    required this.child}
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (optional) Text(
          AppLocalizations.of(context)?.formFieldOptional(title) ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (!optional) Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (subtitle != null) Text(
          subtitle!,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).hintColor
          ),
        ),
        child
      ],
    );
  }
  
}