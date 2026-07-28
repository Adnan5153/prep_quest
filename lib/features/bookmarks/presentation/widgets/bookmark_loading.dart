import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/loading_widget.dart';

/// Loading surface for the initial Bookmarks request.
class BookmarkLoading extends StatelessWidget {
  const BookmarkLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: LoadingWidget(title: 'Loading bookmarks...'),
      ),
    );
  }
}