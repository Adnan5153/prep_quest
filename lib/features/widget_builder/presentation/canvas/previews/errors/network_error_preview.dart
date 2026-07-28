import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/network_error_widget.dart';
import '../../../providers/widget_builder_provider.dart';

class NetworkErrorPreview extends StatelessWidget {
  const NetworkErrorPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 500,
                child: NetworkErrorWidget(
                  onRetry: () {},
                  title: provider.label != 'Hello, Prep Quest'
                      ? provider.label
                      : null,
                  message: provider.subtitle != 'Top navigation preview'
                      ? provider.subtitle
                      : null,
                  retryText: provider.errorRetryText,
                  isLoading: provider.isErrorLoading,
                  showIcon: provider.showErrorIcon,
                  showIllustration: provider.showErrorIllustration,
                  showRetryButton: provider.showErrorRetryButton,
                  errorType: _mapErrorType(provider.errorType),
                  illustration: provider.showErrorIllustration
                      ? Image.asset(
                          'assets/images/onboarding_1.png',
                          height: 140,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text('Error Type Examples', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _buildSmallError(
                  context,
                  'Offline',
                  NetworkErrorType.noInternet,
                ),
                _buildSmallError(
                  context,
                  'Timeout',
                  NetworkErrorType.connectionTimeout,
                ),
                _buildSmallError(
                  context,
                  'Server',
                  NetworkErrorType.serverUnavailable,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallError(
    BuildContext context,
    String label,
    NetworkErrorType type,
  ) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Card(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 200, // Design space for the error widget before scaling down
            height: 200,
            child: NetworkErrorWidget(
              onRetry: () {},
              title: label,
              showIllustration: false,
              showRetryButton: false,
              errorType: type,
              padding: const EdgeInsets.all(AppSpacing.md),
            ),
          ),
        ),
      ),
    );
  }

  NetworkErrorType _mapErrorType(String type) {
    switch (type) {
      case 'noInternet':
        return NetworkErrorType.noInternet;
      case 'connectionTimeout':
        return NetworkErrorType.connectionTimeout;
      case 'serverUnavailable':
        return NetworkErrorType.serverUnavailable;
      case 'requestFailed':
        return NetworkErrorType.requestFailed;
      case 'apiError':
        return NetworkErrorType.apiError;
      case 'offlineMode':
        return NetworkErrorType.offlineMode;
      default:
        return NetworkErrorType.unknownError;
    }
  }
}
