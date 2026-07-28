import 'package:flutter/animation.dart';

class QuizDurations {
  const QuizDurations._();

  static const Duration cardEntrance = Duration(milliseconds: 280);
  static const Duration optionPulse = Duration(milliseconds: 220);
  static const Duration feedbackFade = Duration(milliseconds: 320);
  static const Duration timerPulse = Duration(milliseconds: 600);
  static const Duration rewardBounce = Duration(milliseconds: 360);
  static const Duration scoreCount = Duration(milliseconds: 800);
}

class QuizCurves {
  const QuizCurves._();

  static const Curve entrance = Curves.easeOutCubic;
  static const Curve emphasize = Curves.easeOutBack;
  static const Curve soft = Curves.easeInOutSine;
  static const Curve sharp = Curves.easeInQuart;
}

class QuizLimits {
  const QuizLimits._();

  static const int overviewCardPreviewQuestions = 3;
  static const double readerMaxWidth = 720.0;
  static const double resultMaxWidth = 560.0;
  static const int timerWarningThresholdSeconds = 30;
  static const int timerDangerThresholdSeconds = 10;
}