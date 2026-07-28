import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/loading_widget.dart';

class NoteLoadingState extends StatelessWidget {
  const NoteLoadingState({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: LoadingWidget(
          loaderType: LoaderType.circular,
          title: message,
        ),
      ),
    );
  }
}
