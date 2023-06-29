
import 'package:flutter/cupertino.dart';

class FillWidth extends StatelessWidget {

  final Widget child;

  const FillWidth({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: child,
    );
  }
}