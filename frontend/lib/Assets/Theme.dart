import 'package:flutter/material.dart';
import 'package:weski/Assets/Colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(licentaColors.opacity | licentaColors.licenta_light_red),
    onPrimary: Color(licentaColors.opacity | licentaColors.licenta_light_white),
    secondary: Color(licentaColors.opacity | licentaColors.licenta_light_grey),
    onSecondary: Color(licentaColors.opacity | licentaColors.licenta_light_black),
    surface: Color(licentaColors.opacity | licentaColors.licenta_light_white),
    onSurface: Color(licentaColors.opacity | licentaColors.licenta_light_black),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(licentaColors.opacity | licentaColors.licenta_dark_red),
    onPrimary: Color(licentaColors.opacity | licentaColors.licenta_dark_white),
    secondary: Color(licentaColors.opacity | licentaColors.licenta_dark_grey),
    onSecondary: Color(licentaColors.opacity | licentaColors.licenta_dark_black),
    surface: Color(licentaColors.opacity | licentaColors.licenta_dark_black),
    onSurface: Color(licentaColors.opacity | licentaColors.licenta_dark_white),
  ),
);
