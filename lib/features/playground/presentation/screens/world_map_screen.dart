import 'package:flutter/material.dart';

import 'playground_screen.dart';

/// Lightweight alias that simply re-exports [PlaygroundScreen] so navigation
/// targets resolving to `/playground/map` continue to work.
class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaygroundScreen();
}