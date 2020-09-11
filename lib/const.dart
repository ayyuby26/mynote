import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

// pallete color
const primary = Color(0XFF1b262c);
const secondary = Color(0XFF0f4c75);
const light = Color(0xff3282b8);
const light2 = Color(0xffbbe1fa);
const white = Color(0xffffffff);

final themeData = ThemeData(
  primaryColor: primary, //AppBar
  cursorColor: primary,
  splashColor: primary, //  while on Pressed Color
  applyElevationOverlayColor: true,
  textSelectionColor: light,
  accentColor: Color(0xff14213d),
  appBarTheme: AppBarTheme(
    centerTitle: true,
  ),
);

final shortcutsData = Map<LogicalKeySet, Intent>.from(WidgetsApp.defaultShortcuts)
  ..addAll(<LogicalKeySet, Intent>{
    LogicalKeySet(LogicalKeyboardKey.arrowLeft): const FakeFocusIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowRight): const FakeFocusIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowDown): const FakeFocusIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowUp): const FakeFocusIntent(),
  });
