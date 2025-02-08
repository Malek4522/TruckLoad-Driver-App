import 'package:flutter/material.dart';

enum DeliveryType {
  COLD,         // Cold
  COVERED,      // Covered Goods
  FRAGILE,      // Fragile Items
  LIQUID,       // Liquid
  FLAMBLE       // Flamble
}

class AppColors {
  static const Color primaryBlue = Color(0xFF00359E);
  
  // Light theme colors
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightCard = Colors.white;
  static const Color lightText = Colors.black87;
  static const Color lightTextSecondary = Colors.black54;
  
  // Dark theme colors with blue accents
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkText = Colors.white;
  static const Color darkTextSecondary = Colors.white70;

  // Blue shades
  static const Color lightBlue = Color(0xFF4671D5);  // Lighter shade for dark theme
  static const Color darkBlue = Color(0xFF002B80);   // Darker shade for light theme

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkCard 
        : lightCard;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkText 
        : lightText;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkTextSecondary 
        : lightTextSecondary;
  }

  static Color getAccentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? lightBlue 
        : darkBlue;
  }
} 