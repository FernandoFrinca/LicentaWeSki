import 'package:flutter/material.dart';
import 'package:weski/Assets/Colors.dart';

final ThemeData lightTheme = ThemeData(

  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(

    surface: Color(licentaColors.opacity | licentaColors.background_l),
    onSurface: Color(licentaColors.opacity | licentaColors.colorBlack),

    primary: Color(licentaColors.opacity | licentaColors.custom_l_blue),
    onPrimary: Color(licentaColors.opacity | licentaColors.colorWhite),

    secondary: Color(licentaColors.opacity | licentaColors.custom_l_GrayBlue),
    onSecondary: Color(licentaColors.opacity | licentaColors.colorBlack),

    tertiary: Color(licentaColors.opacity | licentaColors.colorWhite),
    onTertiary: Color(licentaColors.opacity | licentaColors.colorBlack),

  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(licentaColors.opacity | licentaColors.background_d),
    onSurface: Color(licentaColors.opacity | licentaColors.colorWhite),

    primary: Color(licentaColors.opacity | licentaColors.custom_l_blue),
    onPrimary: Color(licentaColors.opacity | licentaColors.colorWhite),

    secondary: Color(licentaColors.opacity | licentaColors.custom_l_GrayBlue),
    onSecondary: Color(licentaColors.opacity | licentaColors.colorBlack),

    tertiary: Color(licentaColors.opacity | licentaColors.colorBlack),
    onTertiary: Color(licentaColors.opacity | licentaColors.colorWhite),

    surfaceContainer: Color(licentaColors.opacity | licentaColors.licenta_dark_grey2),

  ),
);
