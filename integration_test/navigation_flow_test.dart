// Navigation flow integration tests.
//
// Covers the cross-screen flows for Notifications, Bookmarks, and Search on
// stub screens that mirror the production widgets. Real production screens
// under `lib/features/notifications|bookmarks|search` require Firestore reads
// (these flows hydrate via `notificationControllerProvider` /
// `bookmarkControllerProvider`); the stub screens here keep the same user
// affordances so we can verify the interactions offline.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/integration_test_utils.dart';

class _NotificationItem {
  const _NotificationItem(this.id, this.title, this.body);
  final String id;
  final String title;
  final String body;
}

class _NotificationsStub extends StatefulWidget {
  const _NotificationsStub({this.items = const <_NotificationItem>[]});

  final List<_NotificationItem> items;

  @override
  State<_NotificationsStub> createState() => _NotificationsStubState();
}

class _NotificationsStubState extends State<_NotificationsStub> {
  late List<_NotificationItem> _items = List.of(widget.items);
  final Set<String> _read = <String>{};

  @override
  Widget build(BuildContext context) {
    final int unread = _items.where((n) => !_read.contains(n.id)).length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          if (unread > 0)
            TextButton(
              key: const Key('notifications.markAllRead'),
              onPressed: () => setState(() {
                _read.addAll(_items.map((n) => n.id));
              }),
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(child: Text('You are all caught up'))
          : ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                final _NotificationItem item = _items[index];
                return ListTile(
                  key: Key('notifications.item.${item.id}'),
                  leading: Icon(
                    _read.contains(item.id)
                        ? Icons.mark_email_read
                        : Icons.mark_email_unread,
                  ),
                  title: Text(item.title),
                  subtitle: Text(item.body),
                  onTap: () => setState(() => _read.add(item.id)),
                  trailing: IconButton(
                    key: Key('notifications.remove.${item.id}'),
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() {
                      _items = _items.where((n) => n.id != item.id).toList();
                    }),
                  ),
                );
              },
            ),
    );
  }
}

class _BookmarksStub extends StatefulWidget {
  const _BookmarksStub();

  @override
  State<_BookmarksStub> createState() => _BookmarksStubState();
}

class _BookmarksStubState extends State<_BookmarksStub> {
  final List<String> _bookmarks = <String>['Lesson: Algebra basics'];
  final TextEditingController _filter = TextEditingController();

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String query = _filter.text.trim().toLowerCase();
    final List<String> visible = _bookmarks
        .where((s) => query.isEmpty || s.toLowerCase().contains(query))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              key: const Key('bookmarks.search'),
              controller: _filter,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search bookmarks',
              ),
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? const Center(child: Text('No bookmarks'))
                : ListView.builder(
                    itemCount: visible.length,
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      key: Key('bookmarks.item.$index'),
                      leading: const Icon(Icons.bookmark),
                      title: Text(visible[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchStub extends StatefulWidget {
  const _SearchStub({required this.catalogue});

  final List<String> catalogue;

  @override
  State<_SearchStub> createState() => _SearchStubStubState();
}

class _SearchStubStubState extends State<_SearchStub> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final String needle = _query.trim().toLowerCase();
    final List<String> results = needle.isEmpty
        ? const <String>[]
        : widget.catalogue
              .where((s) => s.toLowerCase().contains(needle))
              .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              key: const Key('search.field'),
              autofocus: true,
              onChanged: (String value) => setState(() => _query = value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search lessons, questions, topics',
              ),
            ),
          ),
          Expanded(
            child: _query.trim().isEmpty
                ? const Center(child: Text('Start typing to search'))
                : (results.isEmpty
                      ? const Center(child: Text('No results'))
                      : ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ListTile(
                                key: Key('search.result.$index'),
                                title: Text(results[index]),
                              ),
                        )),
          ),
        ],
      ),
    );
  }
}

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final IntegrationTestHarness harness = IntegrationTestHarness(binding);

  // ---------------------------------------------------------------------------
  // 10. Notifications
  // ---------------------------------------------------------------------------
  testWidgets('notifications - list renders for the user', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: _NotificationsStub(
          items: <_NotificationItem>[
            _NotificationItem(
              '1',
              'Streak reminder',
              'Maintain your 7-day streak',
            ),
            _NotificationItem('2', 'New lesson', 'Algebra basics unlocked'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Streak reminder'), findsOneWidget);
    expect(find.text('New lesson'), findsOneWidget);
  });

  testWidgets('notifications - mark all read removes unread state', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: _NotificationsStub(
          items: <_NotificationItem>[
            _NotificationItem('1', 'Quiz ready', 'Take your daily quiz'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mark all read'), findsOneWidget);
    await tester.tap(find.byKey(const Key('notifications.markAllRead')));
    await tester.pumpAndSettle();
    expect(find.text('Mark all read'), findsNothing);
  });

  testWidgets('notifications - empty state is rendered cleanly', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _NotificationsStub()));
    await tester.pumpAndSettle();
    expect(find.text('You are all caught up'), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // 11. Bookmarks
  // ---------------------------------------------------------------------------
  testWidgets('bookmarks - list shows saved items', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: _BookmarksStub()));
    await tester.pumpAndSettle();

    expect(find.text('Bookmarks'), findsOneWidget);
    expect(find.text('Lesson: Algebra basics'), findsOneWidget);
  });

  testWidgets('bookmarks - filtering narrows the list', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: _BookmarksStub()));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('bookmarks.search')),
      'algebra',
    );
    await tester.pumpAndSettle();

    expect(find.text('Lesson: Algebra basics'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('bookmarks.search')),
      'history',
    );
    await tester.pumpAndSettle();

    expect(find.text('Lesson: Algebra basics'), findsNothing);
    expect(find.text('No bookmarks'), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // 12. Search
  // ---------------------------------------------------------------------------
  testWidgets('search - typing a query renders matching results', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: _SearchStub(
          catalogue: <String>[
            'Algebra basics',
            'Bangladesh history',
            'Indian geography',
            'Algebra advanced',
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start typing to search'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('search.field')), 'algebra');
    await tester.pumpAndSettle();

    expect(find.text('Algebra basics'), findsOneWidget);
    expect(find.text('Algebra advanced'), findsOneWidget);
    expect(find.text('Indian geography'), findsNothing);
  });

  testWidgets('search - zero results shows empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: _SearchStub(catalogue: <String>['Algebra basics']),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('search.field')), 'unmatched');
    await tester.pumpAndSettle();

    expect(find.text('No results'), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // cross-screen nav: navigate from Home -> Notifications -> back
  // ---------------------------------------------------------------------------
  testWidgets('navigation - Home -> Notifications -> Back returns home', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) => Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body: Center(
              child: IconButton(
                key: const Key('home.notifications'),
                tooltip: 'Notifications',
                icon: const Icon(Icons.notifications),
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const _NotificationsStub(
                      items: <_NotificationItem>[
                        _NotificationItem('a', 'a', 'b'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    await tester.tap(find.byKey(const Key('home.notifications')));
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('harness - dismissAnyModal is a no-op on Notifications', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _NotificationsStub()));
    await tester.pumpAndSettle();

    await harness.dismissAnyModal(tester);
    expect(find.text('You are all caught up'), findsOneWidget);
  });

  testWidgets('harness - captureScreenshot is safe on Settings/Bookmark', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _BookmarksStub()));
    await tester.pumpAndSettle();
    await harness.captureScreenshot('bookmarks_home');
    expect(find.text('Bookmarks'), findsOneWidget);
  });
}
