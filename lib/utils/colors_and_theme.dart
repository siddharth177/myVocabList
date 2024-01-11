import 'package:flutter/material.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 207, 214, 250));
var kDarkColorScheme = kColorScheme;

var kThemeData = ThemeData().copyWith(
  colorScheme: kColorScheme,
  brightness: Brightness.dark,
);
var kDartThemeData = kThemeData;
