import 'package:flutter/material.dart';

/// Central color palette pulled from the Tailwind classes / hex values
/// used across all seven HTML mockups (login, dashboard, tickets, manual
/// transaction, ticket detail, sync, settings).
class AppColors {
  AppColors._();

  static const Color black = Colors.black;
  static const Color white = Colors.white;

  // Grays (Tailwind gray-*)
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Alert red (#C11F1F) and logout red (#cc1a1a)
  static const Color alertRed = Color(0xFFC11F1F);
  static const Color logoutRed = Color(0xFFCC1A1A);
  static const Color manualTransactionRed = Color(0xFFE30613);

  // Dark navy "Pending Sync" card (#111C2B)
  static const Color navyCard = Color(0xFF111C2B);

  // Bottom-nav "active" pill styling (unified across screens; the mockups
  // use slightly different blues — D1E4FF / D1E5F7 / D3E3FD / d1e5ff — so
  // one consistent value is used here for a cleaner design system).
  static const Color navActiveBg = Color(0xFFD1E5F7);
  static const Color navActiveText = Color(0xFF1E3A5F);

  // Input backgrounds
  static const Color inputBg = Color(0xFFF3F4F6); // input-bg custom color
  static const Color loginInputBg = Color(0xFFF9FAFB);
}
