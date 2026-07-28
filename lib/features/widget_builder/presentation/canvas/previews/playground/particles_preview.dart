import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/decorations/particles.dart';
import '../../../providers/widget_builder_provider.dart';

class ParticlesPreview extends StatelessWidget {
  const ParticlesPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final particles = _DemoParticles(
      kind: _mapKind(provider.particlesKind),
      count: provider.particlesCount,
      seed: provider.particlesSeed,
    );
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pool Particles', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(
              mode: provider.particlesBrightness,
              child: particles,
            ),
            const SizedBox(height: AppSpacing.xxl),
            const _Section(
              title: 'Kind Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  _ParticlesTile(label: 'Leaf', kind: ParticleKind.leaf),
                  _ParticlesTile(label: 'Sparkle', kind: ParticleKind.sparkle),
                  _ParticlesTile(label: 'Dust', kind: ParticleKind.dust),
                  _ParticlesTile(label: 'Star', kind: ParticleKind.star),
                  _ParticlesTile(label: 'Ambient', kind: ParticleKind.ambient),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoParticles extends StatelessWidget {
  const _DemoParticles({
    required this.kind,
    required this.count,
    required this.seed,
  });

  final ParticleKind kind;
  final int count;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final particles = ParticleFactory(
      seed: seed,
      count: count,
    ).generate(bounds: const Rect.fromLTWH(0, 0, 320, 200));
    return SizedBox(
      width: 320,
      height: 200,
      child: CustomPaint(
        painter: ParticlePainter(
          particles: particles,
          progress: 0.5,
          isDark: Theme.of(context).brightness == Brightness.dark,
        ),
      ),
    );
  }
}

class _ParticlesTile extends StatelessWidget {
  const _ParticlesTile({required this.label, required this.kind});
  final String label;
  final ParticleKind kind;

  @override
  Widget build(BuildContext context) {
    final particles = ParticleFactory(
      seed: 7,
      count: 12,
    ).generate(bounds: const Rect.fromLTWH(0, 0, 160, 120));
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 140,
            child: Center(
              child: SizedBox(
                width: 160,
                height: 120,
                child: CustomPaint(
                  painter: ParticlePainter(
                    particles: particles,
                    progress: 0.5,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}

class _ThemedTileRow extends StatelessWidget {
  const _ThemedTileRow({required this.mode, required this.child});
  final String mode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (mode == 'lightOnly') return _tile(Brightness.light);
    if (mode == 'darkOnly') return _tile(Brightness.dark);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 480;
        final halfWidth = wide
            ? (constraints.maxWidth - AppSpacing.lg) / 2
            : null;
        final tiles = <Widget>[
          SizedBox(width: halfWidth, child: _tile(Brightness.light)),
          SizedBox(width: halfWidth, child: _tile(Brightness.dark)),
        ];
        return wide
            ? Row(children: tiles)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  tiles[0],
                  const SizedBox(height: AppSpacing.lg),
                  tiles[1],
                ],
              );
      },
    );
  }

  Widget _tile(Brightness brightness) {
    final theme = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: brightness == Brightness.dark
            ? const Color(0xFF15151B)
            : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: theme,
        child: Center(child: child),
      ),
    );
  }
}

ParticleKind _mapKind(String value) {
  switch (value) {
    case 'leaf':
      return ParticleKind.leaf;
    case 'sparkle':
      return ParticleKind.sparkle;
    case 'dust':
      return ParticleKind.dust;
    case 'star':
      return ParticleKind.star;
    default:
      return ParticleKind.ambient;
  }
}
