import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';

/// Visual chip that mirrors the status of a payment. Used on the
/// Purchase Flow screen and inside the success dialog.
enum PaymentStatus { idle, processing, success, failure }

extension PaymentStatusX on PaymentStatus {
  Color get color {
    switch (this) {
      case PaymentStatus.idle:
        return AppColors.lightMuted;
      case PaymentStatus.processing:
        return AppColors.info;
      case PaymentStatus.success:
        return AppColors.success;
      case PaymentStatus.failure:
        return AppColors.error;
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentStatus.idle:
        return Icons.lock_outline_rounded;
      case PaymentStatus.processing:
        return Icons.hourglass_top_rounded;
      case PaymentStatus.success:
        return Icons.check_circle_rounded;
      case PaymentStatus.failure:
        return Icons.error_rounded;
    }
  }

  String get label {
    switch (this) {
      case PaymentStatus.idle:
        return 'Awaiting confirmation';
      case PaymentStatus.processing:
        return 'Processing payment';
      case PaymentStatus.success:
        return 'Payment confirmed';
      case PaymentStatus.failure:
        return 'Payment failed';
    }
  }
}

class PaymentStatusIndicator extends StatelessWidget {
  const PaymentStatusIndicator({
    super.key,
    required this.status,
    this.message,
  });

  final PaymentStatus status;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (status == PaymentStatus.processing)
            SizedBox(
              width: AppSizes.iconSm,
              height: AppSizes.iconSm,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            )
          else
            Icon(status.icon, color: color, size: AppSizes.iconSm),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              message ?? status.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
