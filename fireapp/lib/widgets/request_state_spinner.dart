
import 'package:flutter/cupertino.dart';

import '../domain/request_state.dart';

class RequestStateSpinner<T> extends StatelessWidget {

  final RequestState<T> state;
  final Widget child;

  const RequestStateSpinner({
    super.key,
    required this.state,
    required this.child
  });

  static Widget stream<T>({
    Key? key,
    required Stream<RequestState<T>> state,
    required Widget child
  }) {
    return StreamBuilder<RequestState<T>>(
        stream: state,
        builder: (_,d) {
          if (!d.hasData) return Container();
          final data = d.data;
          if (data == null) return Container();
          return RequestStateSpinner(state: data, child: child);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
      if (state is LoadingRequestState) {
        return child;
      }
      return Container();
  }

}