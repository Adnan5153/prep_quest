import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../providers/widget_builder_provider.dart';

class LoadingWidgetPreview extends StatelessWidget {
  const LoadingWidgetPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: LoadingWidget(
          title: provider.loadingTitle,
          subtitle: provider.loadingSubtitle,
          showProgress: provider.showLoadingProgress,
          progress: provider.loadingProgressValue,
          loaderType: _mapLoaderType(provider.loaderType),
        ),
      ),
    );
  }

  LoaderType _mapLoaderType(String type) {
    switch (type) {
      case 'circular':
        return LoaderType.circular;
      case 'linear':
        return LoaderType.linear;
      case 'lottie':
        return LoaderType.lottie;
      default:
        return LoaderType.lottie;
    }
  }
}
