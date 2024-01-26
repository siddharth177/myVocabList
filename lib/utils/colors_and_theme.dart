import 'package:flutter/material.dart';

var kLightColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 207, 214, 250));
var kDarkColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 226, 247, 235));

var kLightThemeData = ThemeData().copyWith(
  colorScheme: kLightColorScheme,
  brightness: Brightness.light,
);
var kDarkThemeData = kLightThemeData.copyWith(
  colorScheme: kDarkColorScheme,
  brightness: Brightness.dark,
);
