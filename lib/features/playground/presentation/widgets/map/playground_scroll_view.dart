import 'package:flutter/material.dart';

import '../../constants/playground_strings.dart';
import 'playground_camera.dart';

class PlaygroundScrollView extends StatefulWidget {
  const PlaygroundScrollView({
    super.key,
    required this.camera,
    required this.contentSize,
    required this.focusTarget,
    required this.child,
  });

  final PlaygroundCamera camera;
  final Size contentSize;
  final Offset? focusTarget;
  final Widget child;

  @override
  State<PlaygroundScrollView> createState() => _PlaygroundScrollViewState();
}

class _PlaygroundScrollViewState extends State<PlaygroundScrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.camera.addListener(_handleCameraChanged);
    _scrollController.addListener(_handleScrollChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.focusTarget != null) {
        _applyCameraFocus(widget.focusTarget!);
      }
    });
  }

  @override
  void didUpdateWidget(covariant PlaygroundScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusTarget != widget.focusTarget &&
        widget.focusTarget != null) {
      _applyCameraFocus(widget.focusTarget!);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScrollChanged);
    _scrollController.dispose();
    widget.camera.removeListener(_handleCameraChanged);
    super.dispose();
  }

  void _handleCameraChanged() {
    if (!_scrollController.hasClients) return;
    final nextOffset = (-widget.camera.translation.dy).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    if ((nextOffset - _scrollController.offset).abs() < 0.5) return;
    _scrollController.jumpTo(nextOffset);
  }

  void _handleScrollChanged() {
    if (!_scrollController.hasClients) return;
    final desired = Offset(0.0, -_scrollController.offset);
    if (desired.dy == widget.camera.translation.dy &&
        desired.dx == widget.camera.translation.dx) {
      return;
    }
    widget.camera.setTranslation(desired);
  }

  void _applyCameraFocus(Offset target) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    widget.camera.snapTo(
      target: target,
      viewport: renderBox.size,
      content: widget.contentSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: PlaygroundStrings.mapCameraSemantic,
      child: RepaintBoundary(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.hardEdge,
          child: SizedBox.fromSize(
            size: widget.contentSize,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
