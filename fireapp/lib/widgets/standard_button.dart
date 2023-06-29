
import 'package:flutter/material.dart';

enum ButtonType {
  primary, secondary, tertiary
}

class StandardButton extends StatelessWidget {

  final ButtonType type;
  final VoidCallback? onPressed;
  final Widget child;

  const StandardButton({
    super.key,
    ButtonType? type,
    required this.onPressed,
    required this.child,
  }): type = type ?? ButtonType.primary;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          child: child
        );
      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          child: child
        );
      default:
        return TextButton(
          onPressed: onPressed,
          child: child
        );
    }
  }

}