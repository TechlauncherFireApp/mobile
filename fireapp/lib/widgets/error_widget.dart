
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef ErrorWidgetRetryCallback = Function();

class ErrorPresentationWidget extends StatelessWidget {

  final Object? exception;
  final String? message;
  final ErrorWidgetRetryCallback? retry;

  const ErrorPresentationWidget({super.key, this.exception, this.message, this.retry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)?.errorTitle ?? "", style: Theme.of(context).textTheme.titleSmall,),
        if (message != null || exception != null) Text(message ?? "$exception"),
        if (retry != null) OutlinedButton(
          onPressed: retry,
          child: Text(AppLocalizations.of(context)?.errorActionRetry ?? "")
        )
      ],
    );
  }

}