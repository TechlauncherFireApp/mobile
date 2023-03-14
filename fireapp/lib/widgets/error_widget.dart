
import 'package:fireapp/base/pretty_exception.dart';
import 'package:fireapp/base/spaced_by.dart';
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
    var message = _message();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)?.errorTitle ?? "", style: Theme.of(context).textTheme.titleLarge,),
        if (message != null) Text(message),
        if (retry != null) SizedBox(
          width: 200,
          child: OutlinedButton(
            onPressed: retry,
            child: Text(AppLocalizations.of(context)?.errorActionRetry ?? "")
          ),
        )
      ].spacedBy(16),
    );
  }

  String? _message() {
    if (message != null) return message;
    if (exception == null) return null;
    if (exception is PrettyException && (exception as PrettyException).message != null) {
      return (exception as PrettyException).message;
    }

    return "$exception";
  }

}