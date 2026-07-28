import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/status_chip.dart';
import '../../../providers/widget_builder_provider.dart';

class StatusChipPreview extends StatelessWidget {
  const StatusChipPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusChip(
              label: provider.chipLabel,
              status: _mapStatus(provider.chipStatus),
              variant: _mapVariant(provider.chipVariant),
              size: _mapSize(provider.chipSize),
              showIcon: provider.showChipIcon,
              animate: provider.enableChipAnimation,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.xxl),
            const Text('Status Examples'),
            const SizedBox(height: AppSpacing.md),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  alignment: WrapAlignment.center,
                  children: [
                    StatusChip(
                      label: 'Success',
                      status: StatusChipStatus.success,
                    ),
                    StatusChip(
                      label: 'Warning',
                      status: StatusChipStatus.warning,
                    ),
                    StatusChip(label: 'Error', status: StatusChipStatus.error),
                    StatusChip(
                      label: 'Premium',
                      status: StatusChipStatus.premium,
                      variant: StatusChipVariant.glass,
                    ),
                    StatusChip(
                      label: 'Locked',
                      status: StatusChipStatus.locked,
                      variant: StatusChipVariant.outlined,
                    ),
                    StatusChip(
                      label: 'Live',
                      status: StatusChipStatus.live,
                      pulse: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  StatusChipStatus _mapStatus(String status) {
    switch (status) {
      case 'success':
        return StatusChipStatus.success;
      case 'warning':
        return StatusChipStatus.warning;
      case 'error':
        return StatusChipStatus.error;
      case 'info':
        return StatusChipStatus.info;
      case 'premium':
        return StatusChipStatus.premium;
      case 'locked':
        return StatusChipStatus.locked;
      case 'completed':
        return StatusChipStatus.completed;
      case 'pending':
        return StatusChipStatus.pending;
      case 'inProgress':
        return StatusChipStatus.inProgress;
      case 'newStatus':
        return StatusChipStatus.newStatus;
      case 'live':
        return StatusChipStatus.live;
      case 'offline':
        return StatusChipStatus.offline;
      case 'online':
        return StatusChipStatus.online;
      case 'expired':
        return StatusChipStatus.expired;
      default:
        return StatusChipStatus.info;
    }
  }

  StatusChipVariant _mapVariant(String variant) {
    switch (variant) {
      case 'filled':
        return StatusChipVariant.filled;
      case 'outlined':
        return StatusChipVariant.outlined;
      case 'glass':
        return StatusChipVariant.glass;
      case 'gradient':
        return StatusChipVariant.gradient;
      case 'soft':
        return StatusChipVariant.soft;
      case 'pill':
        return StatusChipVariant.pill;
      default:
        return StatusChipVariant.soft;
    }
  }

  StatusChipSize _mapSize(String size) {
    switch (size) {
      case 'small':
        return StatusChipSize.small;
      case 'medium':
        return StatusChipSize.medium;
      case 'large':
        return StatusChipSize.large;
      default:
        return StatusChipSize.medium;
    }
  }
}
