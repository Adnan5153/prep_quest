import 'package:flutter/animation.dart';

abstract class AdminMotion {
  const AdminMotion._();

  static const Duration micro = Duration(milliseconds: 80);
  static const Duration tap = Duration(milliseconds: 120);
  static const Duration state = Duration(milliseconds: 240);
  static const Duration dialog = Duration(milliseconds: 280);
  static const Duration panel = Duration(milliseconds: 320);
  static const Duration camera = Duration(milliseconds: 600);
  static const Duration undo = Duration(milliseconds: 180);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeIn = Curves.easeInCubic;
  static const Curve easeInOut = Curves.easeInOutCubic;
  static const Curve spring = Curves.easeOutBack;
  static const Curve snap = Curves.easeOutCubic;
}
