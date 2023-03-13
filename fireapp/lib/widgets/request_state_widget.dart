
import 'package:fireapp/domain/request_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'error_widget.dart';

typedef RequestStateWidgetBuilder<T> = Widget Function(BuildContext context, T result);

class RequestStateWidget<T> extends StatelessWidget {

  final RequestStateWidgetBuilder<T> child;
  final RequestState<T> state;
  final ErrorWidgetRetryCallback? retry;

  const RequestStateWidget({super.key, required this.child, required this.state, this.retry});

  @override
  Widget build(BuildContext context) {
    if (state is SuccessRequestState) {
      return child(context, (state as SuccessRequestState).result);
    }
    if (state is ExceptionRequestState) {
      return ErrorPresentationWidget(
        exception: (state as ExceptionRequestState).exception,
        retry: retry,
      );
    }
    return const CircularProgressIndicator();
  }

}