import 'package:flutter/material.dart';
import '../allConstants/color_constants.dart';

final appTheme = ThemeData(
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
);
