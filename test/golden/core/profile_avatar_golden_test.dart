import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep_quest/core/widgets/profile_avatar.dart';

import '../../helpers/golden_test_utils.dart';

/// Golden tests for the [ProfileAvatar] widget.
///
/// NOTE: `lib/core/widgets/avatar.dart` is currently an empty stub.
/// The unified avatar implementation lives in
/// `lib/core/widgets/profile_avatar.dart`. These goldens target the
/// production implementation. When the unified `Avatar` widget ships,
/// re-export from `avatar.dart` and add a parallel suite.
void main() {
  // Standard framing used across all captures — gives the avatar room
  // to render its optional badges without being clipped.
  Widget frame(Widget child) => Center(child: child);

  // ---------------------------------------------------------------------------
  // Initial-only fallback (no imageUrl / assetImage)
  // ---------------------------------------------------------------------------
  group('ProfileAvatar · initials', () {
    testWidgets('initials · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_initials',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const ProfileAvatar(
            initials: 'JD',
            name: 'John Doe',
            size: 96,
          ),
        ),
      );
    });

    testWidgets('initials · single-letter · light+dark', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_initials_single',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const ProfileAvatar(
            initials: 'A',
            name: 'Alice',
            size: 96,
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Network image — golden file is recorded against the loading/error
  // placeholder because the network call is unreachable in unit tests.
  // ---------------------------------------------------------------------------
  group('ProfileAvatar · image states', () {
    testWidgets('with imageUrl · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_with_image',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const ProfileAvatar(
            imageUrl: 'https://example.com/avatar.png',
            name: 'Jane Doe',
            size: 96,
          ),
        ),
      );
    });

    testWidgets('loading state · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_loading',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const ProfileAvatar(
            imageUrl: 'https://example.com/avatar.png',
            name: 'Jane Doe',
            size: 96,
            loading: true,
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Decorative overlays: online, premium, verified, edit
  // ---------------------------------------------------------------------------
  group('ProfileAvatar · overlays', () {
    testWidgets('online indicator · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_online',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const ProfileAvatar(
            initials: 'JD',
            name: 'John Doe',
            size: 96,
            showOnlineIndicator: true,
            isOnline: true,
          ),
        ),
      );
    });

    testWidgets('offline indicator · light+dark', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_offline',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const ProfileAvatar(
            initials: 'JD',
            name: 'John Doe',
            size: 96,
            showOnlineIndicator: true,
            isOnline: false,
          ),
        ),
      );
    });

    testWidgets('premium badge · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 220);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_premium',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const ProfileAvatar(
            initials: 'JD',
            name: 'John Doe',
            size: 96,
            showPremiumBadge: true,
          ),
        ),
      );
    });

    testWidgets('verified badge · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 220);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_verified',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const ProfileAvatar(
            initials: 'JD',
            name: 'John Doe',
            size: 96,
            showVerifiedBadge: true,
          ),
        ),
      );
    });

    testWidgets('edit button · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 220);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_edit',
        builder: (BuildContext context, ThemeMode mode) => frame(
          ProfileAvatar(
            initials: 'JD',
            name: 'John Doe',
            size: 96,
            showEditButton: true,
            onEdit: () {},
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Sizing — small / medium / large
  // ---------------------------------------------------------------------------
  group('ProfileAvatar · sizes', () {
    testWidgets('small (48) · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_size_small',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const ProfileAvatar(initials: 'JD', name: 'John Doe', size: 48),
        ),
      );
    });

    testWidgets('large (128) · light+dark', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 220);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await captureGoldenPair(
        tester,
        'core/profile_avatar_size_large',
        builder: (BuildContext context, ThemeMode mode) => frame(
          const ProfileAvatar(initials: 'JD', name: 'John Doe', size: 128),
        ),
      );
    });
  });
}