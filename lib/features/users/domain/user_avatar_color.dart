import 'package:flutter/material.dart';

/// Preset accent colors for profile avatars on the user list / add flow.
const List<Color> kUserAvatarPresetColors = [
  Color(0xFF00897B),
  Color(0xFF5E35B1),
  Color(0xFFE53935),
  Color(0xFFFB8C00),
  Color(0xFF1E88E5),
  Color(0xFF43A047),
  Color(0xFF8E24AA),
  Color(0xFF6D4C41),
];

Color avatarColorForUser(String userId, {int? storedValue}) {
  if (storedValue != null) {
    return Color(storedValue);
  }
  final hash = userId.codeUnits.fold<int>(0, (a, b) => a + b);
  return kUserAvatarPresetColors[hash % kUserAvatarPresetColors.length];
}
