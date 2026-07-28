import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/widget_constants.dart';
import '../../../providers/widget_builder_provider.dart';

class WidgetConstantsPreview extends StatelessWidget {
  const WidgetConstantsPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String query = provider.constantsSearchQuery.toLowerCase();

    // Map of categories and their constants
    final Map<String, Map<String, dynamic>> categories = {
      'Animation': {
        'fastAnimationDuration': WidgetConstants.fastAnimationDuration,
        'normalAnimationDuration': WidgetConstants.normalAnimationDuration,
        'slowAnimationDuration': WidgetConstants.slowAnimationDuration,
        'pageTransitionDuration': WidgetConstants.pageTransitionDuration,
        'heroAnimationDuration': WidgetConstants.heroAnimationDuration,
        'hoverAnimationDuration': WidgetConstants.hoverAnimationDuration,
        'pressAnimationDuration': WidgetConstants.pressAnimationDuration,
        'loadingAnimationDuration': WidgetConstants.loadingAnimationDuration,
        'snackbarAnimationDuration': WidgetConstants.snackbarAnimationDuration,
        'tooltipAnimationDuration': WidgetConstants.tooltipAnimationDuration,
        'defaultAnimationCurve': WidgetConstants.defaultAnimationCurve,
        'bounceCurve': WidgetConstants.bounceCurve,
        'easeCurve': WidgetConstants.easeCurve,
        'easeInCurve': WidgetConstants.easeInCurve,
        'easeOutCurve': WidgetConstants.easeOutCurve,
        'easeInOutCurve': WidgetConstants.easeInOutCurve,
        'fastOutSlowInCurve': WidgetConstants.fastOutSlowInCurve,
      },
      'Elevation': {
        'buttonElevation': WidgetConstants.buttonElevation,
        'cardElevation': WidgetConstants.cardElevation,
        'dialogElevation': WidgetConstants.dialogElevation,
        'drawerElevation': WidgetConstants.drawerElevation,
        'appBarElevation': WidgetConstants.appBarElevation,
        'navigationBarElevation': WidgetConstants.navigationBarElevation,
        'navigationRailElevation': WidgetConstants.navigationRailElevation,
        'bottomSheetElevation': WidgetConstants.bottomSheetElevation,
        'floatingActionButtonElevation':
            WidgetConstants.floatingActionButtonElevation,
      },
      'Opacity': {
        'disabledOpacity': WidgetConstants.disabledOpacity,
        'hoverOpacity': WidgetConstants.hoverOpacity,
        'pressedOpacity': WidgetConstants.pressedOpacity,
        'overlayOpacity': WidgetConstants.overlayOpacity,
        'glassOpacity': WidgetConstants.glassOpacity,
        'focusOpacity': WidgetConstants.focusOpacity,
        'dragOpacity': WidgetConstants.dragOpacity,
        'selectedOpacity': WidgetConstants.selectedOpacity,
      },
      'Borders': {
        'defaultBorderWidth': WidgetConstants.defaultBorderWidth,
        'focusedBorderWidth': WidgetConstants.focusedBorderWidth,
        'selectedBorderWidth': WidgetConstants.selectedBorderWidth,
        'dividerThickness': WidgetConstants.dividerThickness,
        'outlineThickness': WidgetConstants.outlineThickness,
      },
      'Buttons': {
        'smallButtonHeight': WidgetConstants.smallButtonHeight,
        'mediumButtonHeight': WidgetConstants.mediumButtonHeight,
        'largeButtonHeight': WidgetConstants.largeButtonHeight,
        'buttonMinWidth': WidgetConstants.buttonMinWidth,
        'buttonIconSize': WidgetConstants.buttonIconSize,
        'buttonLoadingSize': WidgetConstants.buttonLoadingSize,
      },
      'Cards': {
        'cardMinHeight': WidgetConstants.cardMinHeight,
        'cardMaxWidth': WidgetConstants.cardMaxWidth,
        'glassBlurSigma': WidgetConstants.glassBlurSigma,
        'glassBorderOpacity': WidgetConstants.glassBorderOpacity,
        'glassShadowBlur': WidgetConstants.glassShadowBlur,
        'glassShadowSpread': WidgetConstants.glassShadowSpread,
      },
      'Icons': {
        'smallIconSize': WidgetConstants.smallIconSize,
        'mediumIconSize': WidgetConstants.mediumIconSize,
        'largeIconSize': WidgetConstants.largeIconSize,
        'extraLargeIconSize': WidgetConstants.extraLargeIconSize,
      },
      'Avatars': {
        'smallAvatarSize': WidgetConstants.smallAvatarSize,
        'mediumAvatarSize': WidgetConstants.mediumAvatarSize,
        'largeAvatarSize': WidgetConstants.largeAvatarSize,
        'avatarBorderWidth': WidgetConstants.avatarBorderWidth,
        'onlineIndicatorSize': WidgetConstants.onlineIndicatorSize,
      },
      'Chips': {
        'chipHeight': WidgetConstants.chipHeight,
        'chipMinWidth': WidgetConstants.chipMinWidth,
        'chipIconSize': WidgetConstants.chipIconSize,
      },
      'Progress Indicators': {
        'linearProgressHeight': WidgetConstants.linearProgressHeight,
        'circularProgressStrokeWidth':
            WidgetConstants.circularProgressStrokeWidth,
        'progressAnimationDuration': WidgetConstants.progressAnimationDuration,
      },
      'Loaders': {
        'smallLoaderSize': WidgetConstants.smallLoaderSize,
        'mediumLoaderSize': WidgetConstants.mediumLoaderSize,
        'largeLoaderSize': WidgetConstants.largeLoaderSize,
        'fullscreenOverlayOpacity': WidgetConstants.fullscreenOverlayOpacity,
      },
      'Navigation': {
        'appBarHeight': WidgetConstants.appBarHeight,
        'sliverExpandedHeight': WidgetConstants.sliverExpandedHeight,
        'bottomNavigationHeight': WidgetConstants.bottomNavigationHeight,
        'navigationRailWidth': WidgetConstants.navigationRailWidth,
        'drawerWidth': WidgetConstants.drawerWidth,
      },
      'Dialogs': {
        'dialogMaxWidth': WidgetConstants.dialogMaxWidth,
        'bottomSheetMaxWidth': WidgetConstants.bottomSheetMaxWidth,
        'snackbarMaxWidth': WidgetConstants.snackbarMaxWidth,
      },
      'Badges': {
        'smallBadgeSize': WidgetConstants.smallBadgeSize,
        'mediumBadgeSize': WidgetConstants.mediumBadgeSize,
        'largeBadgeSize': WidgetConstants.largeBadgeSize,
        'premiumBadgeSize': WidgetConstants.premiumBadgeSize,
      },
      'Widget Builder Defaults': {
        'defaultPreviewTitle': WidgetConstants.defaultPreviewTitle,
        'defaultPreviewSubtitle': WidgetConstants.defaultPreviewSubtitle,
        'defaultButtonLabel': WidgetConstants.defaultButtonLabel,
        'defaultCardTitle': WidgetConstants.defaultCardTitle,
        'defaultChipLabel': WidgetConstants.defaultChipLabel,
        'defaultStatusLabel': WidgetConstants.defaultStatusLabel,
        'defaultAvatarName': WidgetConstants.defaultAvatarName,
        'defaultTagLabel': WidgetConstants.defaultTagLabel,
      },
    };

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ListView(
        children: categories.entries.map((category) {
          final String categoryName = category.key;
          final Map<String, dynamic> constants = category.value;

          // Filter constants based on query
          final filteredConstants = constants.entries
              .where(
                (e) =>
                    e.key.toLowerCase().contains(query) ||
                    categoryName.toLowerCase().contains(query),
              )
              .toList();

          if (filteredConstants.isEmpty) return const SizedBox.shrink();

          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: ExpansionTile(
              initiallyExpanded: query.isNotEmpty,
              title: Text(
                categoryName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${filteredConstants.length} constants',
                style: theme.textTheme.labelSmall,
              ),
              children: filteredConstants.map((constant) {
                return ListTile(
                  title: Text(constant.key, style: theme.textTheme.bodyMedium),
                  trailing: Text(
                    _formatValue(constant.value),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Courier', // Using system font for code look
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value is Duration) {
      if (value.inSeconds > 0) return '${value.inSeconds}s';
      return '${value.inMilliseconds}ms';
    }
    if (value is Color) {
      return '#${value.toARGB32().toRadixString(16).toUpperCase().substring(2)}';
    }
    if (value is Curve) {
      return value.runtimeType.toString();
    }
    return value.toString();
  }
}
