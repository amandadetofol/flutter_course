import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(136, 14, 79, 1);
const primaryColorLight = Color.fromRGBO(96, 0, 39, 1);
const primaryColorDark = Color.fromRGBO(188, 71, 123, 1);

final appTheme = ThemeData(
  primaryColor: primaryColor,
  primaryColorLight: primaryColorLight,
  primaryColorDark: primaryColorDark,
  highlightColor: primaryColor,
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: primaryColorLight,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: primaryColorDark),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: primaryColorLight),
    ),
    alignLabelWithHint: true,
    iconColor: primaryColor,
    hoverColor: primaryColorDark,
    focusColor: Colors.black12,
    floatingLabelStyle: TextStyle(
      color: Colors.black,
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStatePropertyAll(
        EdgeInsets.all(12),
      ),
      backgroundColor: MaterialStatePropertyAll(primaryColorLight),
    ),
  ),
);
