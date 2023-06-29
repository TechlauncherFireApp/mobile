
import 'package:flutter/material.dart';

class SimpleDivider extends StatelessWidget {

  final Color color;

  const SimpleDivider({
    super.key,
    Color? color
  }) : color = color ?? Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      color: Theme.of(context).colorScheme.outline,
    );
  }
}