import 'package:flutter/cupertino.dart';

class StreamFormField<T> extends StatelessWidget {

  final Stream<T> stream;
  final Widget Function(BuildContext, T?) builder;

  const StreamFormField({
    super.key,
    required this.stream,
    required this.builder
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, value) {
        if (value.data == null) return builder(context, null);
        return builder(context, value.data as T?);
      }
    );
  }
}