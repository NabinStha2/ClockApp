import 'package:flutter/material.dart';

List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];

class GradientColors {
  final List<Color> colors;
  GradientColors({required this.colors});
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(colors: sky),
    GradientColors(colors: sunset),
    GradientColors(colors: sea),
    GradientColors(colors: mango),
    GradientColors(colors: fire),
  ];
}
