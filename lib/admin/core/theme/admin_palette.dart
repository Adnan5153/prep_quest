import 'package:flutter/material.dart';

abstract class AdminPalette {
  const AdminPalette._();

  static const Color graphite = Color(0xFF1F2937);
  static const Color slate = Color(0xFF374151);
  static const Color ash = Color(0xFF6B7280);
  static const Color ivory = Color(0xFFF9FAFB);
  static const Color paper = Color(0xFFFFFFFF);
  static const Color hairline = Color(0xFFE5E7EB);
  static const Color hairlineDark = Color(0xFF111827);

  static const Color accent = Color(0xFF2563EB);
  static const Color accentMuted = Color(0xFF3B82F6);

  static const Color statusDraft = Color(0xFF9CA3AF);
  static const Color statusInReview = Color(0xFFF59E0B);
  static const Color statusTesting = Color(0xFF6366F1);
  static const Color statusPublished = Color(0xFF10B981);
  static const Color statusArchived = Color(0xFF3B82F6);
  static const Color statusRolledBack = Color(0xFFEF4444);

  static const Color danger = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF0EA5E9);

  static const Color selectionFill = Color(0x332563EB);
  static const Color selectionStroke = Color(0xFF2563EB);
  static const Color snapGuide = Color(0xFFEC4899);
  static const Color gridMinor = Color(0x14000000);
  static const Color gridMajor = Color(0x33000000);

  static const Color viewportBackground = Color(0xFFF3F4F6);
  static const Color viewportBackgroundDark = Color(0xFF111827);
  static const Color canvasPaper = Color(0xFFFAFAF7);
  static const Color canvasPaperDark = Color(0xFF0B1220);

  static const Color nodeLocked = Color(0xFF6B7280);
  static const Color nodeAvailable = Color(0xFF2563EB);
  static const Color nodeCompleted = Color(0xFF10B981);
  static const Color bossGate = Color(0xFFDC2626);
}
