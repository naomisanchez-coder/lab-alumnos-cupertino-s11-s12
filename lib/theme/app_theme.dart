import 'package:flutter/cupertino.dart';

/// Paleta y tipografía compartidas por todas las pantallas Cupertino.
abstract final class AppTheme {
  static const primaryColor = Color(0xFF5B40CF);
  static const secondary = Color(0xFF735FE0);
  static const lightPurple = Color(0xFFF0EBFF);
  static const backgroundColor = Color(0xFFF2F2F7);
  static const surface = Color(0xFFFFFFFF);
  static const textColor = Color(0xFF1C1C1E);
  static const muted = Color(0xFF6C6C70);
  static const success = Color(0xFF187A38);
  static const successSoft = Color(0xFFE2F7E8);
  static const danger = Color(0xFFB3261E);
  static const dangerSoft = Color(0xFFFFE5E5);
  static const heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  static const caption = TextStyle(fontSize: 14, height: 1.5, color: muted);
  static const lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    barBackgroundColor: surface,
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(fontSize: 16, color: textColor),
    ),
  );
}
