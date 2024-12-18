import 'package:flutter/material.dart';

ThemeData generateMaterialImageCropperTheme(BuildContext context) {
  final outerTheme = Theme.of(context);

  return ThemeData.localize(
    ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5469FF),
        primary: const Color(0xFF5469FF),
        brightness: Brightness.dark,
        onSurface: Colors.black,
      ),
      useMaterial3: outerTheme.useMaterial3,
    ),
    outerTheme.textTheme,
  ).copyWith(scaffoldBackgroundColor: Colors.black);
}
