// app_colors.dart — in lib/core/constants/
import 'dart:ui';

class AppColors {
  AppColors._();
  // Blue Theme Color Palette
  static const Color primary = Color(0xFF1E3A8A);         // Deep Blue
  static const Color secondary = Color(0xFF3B82F6);       // Bright Blue
  static const Color accent = Color(0xFF06B6D4);          // Cyan Blue
  static const Color success = Color(0xFF10B981);         // Emerald Green
  static const Color warning = Color(0xFFF59E0B);         // Amber
  static const Color error = Color(0xFFEF4444);           // Red
  
  // Background Colors
  static const Color background = Color(0xFFF8FAFC);      // Light Gray Background
  static const Color surface = Color(0xFFFFFFFF);         // White Surface
  static const Color cardBackground = Color(0xFFFFFFFF);  // White Cards
  
  // Text Colors
  static const Color textDark = Color(0xFF1E293B);        // Dark Gray Text
  static const Color textMedium = Color(0xFF64748B);      // Medium Gray Text
  static const Color textLight = Color(0xFF94A3B8);       // Light Gray Text
  
  // Gradient Colors
  static const Color gradientStart = Color(0xFF1E40AF);   // Blue Gradient Start
  static const Color gradientEnd = Color(0xFF3B82F6);     // Blue Gradient End
}
