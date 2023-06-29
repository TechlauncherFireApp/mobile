
import 'package:fireapp/style/typography.dart';
import 'package:flutter/material.dart';

// Color(0xFFF4E4E2)

const buttonStyle = ButtonStyle(
  elevation: MaterialStatePropertyAll(0),
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8))
    )
  ),
  padding: MaterialStatePropertyAll(
    EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 16
    )
  )
);

ThemeData theme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      background: Color(0xFFF7FAFA),
      surface: Colors.white,
      primary: Color(0xFFD3503D),
      secondary: Color(0xFF3DBFD3),
      tertiary: Color(0xFFD33D74)
    ),
    backgroundColor: Color(0xFFF7FAFA),
    scaffoldBackgroundColor: Color(0xFFF7FAFA),
    primaryColor: Color(0xFFD3503D),
    textTheme: textTheme,
    buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16
        )
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: buttonStyle
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: buttonStyle
    ),
    textButtonTheme: const TextButtonThemeData(
      style: buttonStyle
    )
  );
}

InputDecoration textFieldStyle(
    BuildContext context,
    {
      BorderRadius? radius
    }
) {
  radius = radius ?? BorderRadius.circular(0.5.rdp());
  return InputDecoration(
    filled: true,
    fillColor: Theme.of(context).colorScheme.surface,
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 2
      )
    ),
    border: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    ),
    focusColor: Theme.of(context).colorScheme.primary,
    contentPadding: EdgeInsets.symmetric(
      vertical: 0.5.rdp(),
      horizontal: 1.0.rdp()
    )
  );
}

const baseUnit = 16;

extension DpInt on int {

  double rdp() {
    return toDouble() * baseUnit;
  }

}

extension DpDouble on double {

  double rdp() {
    return this * baseUnit;
  }

}
