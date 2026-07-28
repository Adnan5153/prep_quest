import 'package:flutter/animation.dart';

class LessonDurations {
  const LessonDurations._();

  static const Duration sectionFade = Duration(milliseconds: 240);
  static const Duration cardEntrance = Duration(milliseconds: 280);
  static const Duration exampleEntrance = Duration(milliseconds: 220);
  static const Duration rewardPulse = Duration(milliseconds: 600);
  static const Duration bookmarkBounce = Duration(milliseconds: 320);
}

class LessonCurves {
  const LessonCurves._();

  static const Curve entrance = Curves.easeOutCubic;
  static const Curve emphasize = Curves.easeOutBack;
  static const Curve soft = Curves.easeInOutSine;
}

class LessonLimits {
  const LessonLimits._();

  static const int maxSectionsPerPage = 1;
  static const int previewSections = 2;
  static const double readerMaxWidth = 720.0;
}