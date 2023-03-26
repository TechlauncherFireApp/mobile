
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/di.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'error_widget.dart';

typedef RequestStateWidgetBuilder<T> = Widget Function(BuildContext context, T result);

class RequestStateWidget<T> extends StatelessWidget {

  final RequestStateWidgetBuilder<T> child;
  final RequestState<T> state;
  final ErrorWidgetRetryCallback? retry;
  final bool shouldExpand;

  const RequestStateWidget({super.key, required this.state, this.retry, this.shouldExpand = true, required this.child});

  static Widget stream<T>({
    Key? key,
    required Stream<RequestState<T>> state,
    required ErrorWidgetRetryCallback retry,
    bool shouldExpand = true,
    required RequestStateWidgetBuilder<T> child
  }) {
    return StreamBuilder<RequestState<T>>(
      stream: state,
      builder: (_,d) {
        var state = d.data;
        if (state == null && d.hasError) {
          state = RequestState.exception(d.error);
        }
        if (state == null) return Container();

        return RequestStateWidget(
            key: key,
            state: state,
            retry: retry,
            shouldExpand: shouldExpand,
            child: child
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    if (state is SuccessRequestState) {
      return _wrapper(child(context, (state as SuccessRequestState).result));
    }
    if (state is ExceptionRequestState) {
      return _wrapper(ErrorPresentationWidget(
        exception: (state as ExceptionRequestState).exception,
        retry: retry,
      ));
    }
    return _wrapper(const CircularProgressIndicator());
  }
  
  Widget _wrapper(Widget content) {
    if (shouldExpand) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: content,
        ),
      );
    } else {
      return content;
    }
  }

}