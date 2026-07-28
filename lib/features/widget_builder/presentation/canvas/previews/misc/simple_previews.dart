import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../../../core/widgets/custom_checkbox.dart';
import '../../../../../../core/widgets/coming_soon.dart';
import '../../../../../../core/widgets/category_chip.dart';
import '../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../core/widgets/custom_drawer.dart';
import '../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../core/widgets/custom_navigation_rail.dart';
import '../../../../../../core/widgets/custom_radio.dart';
import '../../../../../../core/widgets/custom_search_field.dart';
import '../../../../../../core/widgets/custom_slider.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../providers/widget_builder_provider.dart';

class SimplePreviews {
  static Widget outlinedButton(WidgetBuilderProvider provider) {
    return OutlinedButton(onPressed: null, child: Text(provider.label));
  }

  static Widget card(WidgetBuilderProvider provider, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(provider.label, style: theme.textTheme.titleMedium),
      ),
    );
  }

  static Widget badgeChip(WidgetBuilderProvider provider) {
    return Chip(
      label: Text(provider.label),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }

  static Widget progressBar(WidgetBuilderProvider provider) {
    return SizedBox(
      width: 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const LinearProgressIndicator(value: 0.65),
          const SizedBox(height: AppSpacing.sm),
          Text(provider.label),
        ],
      ),
    );
  }
}

class BottomNavigationPreview extends StatefulWidget {
  const BottomNavigationPreview({super.key});

  @override
  State<BottomNavigationPreview> createState() =>
      _BottomNavigationPreviewState();
}

class _BottomNavigationPreviewState extends State<BottomNavigationPreview> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      height: 220,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: const Center(child: Text('Page Content')),
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Play',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz_outlined),
              activeIcon: Icon(Icons.quiz),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class CheckboxPreview extends StatefulWidget {
  const CheckboxPreview({super.key});

  @override
  State<CheckboxPreview> createState() => _CheckboxPreviewState();
}

class _CheckboxPreviewState extends State<CheckboxPreview> {
  bool _rememberMe = true;
  bool _notifications = false;
  bool _premium = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomCheckbox(
                value: _rememberMe,
                title: 'Remember Me',
                subtitle: 'Keep me signed in',
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              CustomCheckbox(
                value: _notifications,
                title: 'Push Notifications',
                subtitle: 'Receive daily reminders',
                onChanged: (value) {
                  setState(() {
                    _notifications = value;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              CustomCheckbox(
                value: _premium,
                title: 'Premium Features',
                subtitle: 'Unlock AI Tutor and Mock Tests',
                checkboxFirst: false,
                onChanged: (value) {
                  setState(() {
                    _premium = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComingSoonPreview extends StatelessWidget {
  const ComingSoonPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 420,
      child: ComingSoon(
        title: 'AI Tutor',
        subtitle:
            'Our AI-powered tutor is almost ready.\nStay tuned for the next update!',
        icon: Icons.smart_toy_outlined,
        showButton: true,
        buttonText: 'Notify Me',
      ),
    );
  }
}

class CategoryChipPreview extends StatefulWidget {
  const CategoryChipPreview({super.key});

  @override
  State<CategoryChipPreview> createState() => _CategoryChipPreviewState();
}

class _CategoryChipPreviewState extends State<CategoryChipPreview> {
  int _selectedIndex = 0;
  final List<String> _categories = const [
    'BCS',
    'Bank',
    'Primary',
    'English',
    'Math',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 460,
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: List.generate(_categories.length, (index) {
          return CategoryChip(
            label: _categories[index],
            count: (index + 1) * 25,
            selected: _selectedIndex == index,
            leading: const Icon(Icons.school_outlined, size: 18),
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
          );
        }),
      ),
    );
  }
}

class DividerPreview extends StatelessWidget {
  const DividerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Simple Divider'),
          CustomDivider(),
          SizedBox(height: AppSpacing.lg),
          Text('Divider With Label'),
          CustomDivider(label: 'OR'),
          SizedBox(height: AppSpacing.lg),
          Text('Divider With Icon'),
          CustomDivider(label: 'Premium', icon: Icons.workspace_premium),
          SizedBox(height: AppSpacing.lg),
          Text('Dashed Divider'),
          CustomDivider(dashed: true, label: 'Section'),
        ],
      ),
    );
  }
}

class DrawerPreview extends StatelessWidget {
  const DrawerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 520,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Material(
          elevation: AppSizes.cardElevation,
          child: CustomDrawer(
            userName: 'Ahmed Yeasin',
            userEmail: 'ahmed@example.com',
            footerText: 'PrepQuest',
            items: [
              DrawerMenuItem(
                title: 'Playground',
                icon: Icons.explore_outlined,
                selected: true,
                onTap: () {},
              ),
              DrawerMenuItem(
                title: 'Guidebook',
                icon: Icons.menu_book_outlined,
                onTap: () {},
              ),
              DrawerMenuItem(
                title: 'Question Bank',
                icon: Icons.quiz_outlined,
                badge: 'NEW',
                onTap: () {},
              ),
              DrawerMenuItem(
                title: 'Mock Tests',
                icon: Icons.assignment_outlined,
                onTap: () {},
              ),
              DrawerMenuItem(
                title: 'Leaderboard',
                icon: Icons.leaderboard_outlined,
                onTap: () {},
              ),
              DrawerMenuItem(
                title: 'Subscription',
                icon: Icons.workspace_premium_outlined,
                badge: 'PRO',
                onTap: () {},
              ),
              DrawerMenuItem(
                title: 'Settings',
                icon: Icons.settings_outlined,
                onTap: () {},
              ),
              DrawerMenuItem(
                title: 'Logout',
                icon: Icons.logout_outlined,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownPreview extends StatefulWidget {
  const DropdownPreview({super.key});

  @override
  State<DropdownPreview> createState() => _DropdownPreviewState();
}

class _DropdownPreviewState extends State<DropdownPreview> {
  final List<String> _items = const [
    'BCS',
    'Bank',
    'Primary Teacher',
    'University',
    'Admission',
  ];
  String? _selected = 'BCS';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: CustomDropdown<String>(
        value: _selected,
        labelText: 'Exam Track',
        hintText: 'Select exam',
        prefixIcon: const Icon(Icons.school_outlined),
        items: _items,
        itemLabelBuilder: (value) => value,
        onChanged: (value) {
          setState(() {
            _selected = value;
          });
        },
      ),
    );
  }
}

class NavigationRailPreview extends StatefulWidget {
  const NavigationRailPreview({super.key});

  @override
  State<NavigationRailPreview> createState() => _NavigationRailPreviewState();
}

class _NavigationRailPreviewState extends State<NavigationRailPreview> {
  int _selectedIndex = 0;
  bool _extended = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Card(
        child: Row(
          children: [
            CustomNavigationRail(
              extended: _extended,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              leading: const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Icon(
                  Icons.school,
                  size: AppSizes.iconLg,
                  color: AppColors.primary,
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: IconButton(
                  tooltip: 'Toggle Rail',
                  icon: Icon(
                    _extended
                        ? Icons.keyboard_double_arrow_left
                        : Icons.keyboard_double_arrow_right,
                  ),
                  onPressed: () {
                    setState(() {
                      _extended = !_extended;
                    });
                  },
                ),
              ),
              destinations: const [
                CustomNavigationRailDestination(
                  label: 'Playground',
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore,
                ),
                CustomNavigationRailDestination(
                  label: 'Guidebook',
                  icon: Icons.menu_book_outlined,
                  selectedIcon: Icons.menu_book,
                ),
                CustomNavigationRailDestination(
                  label: 'Question Bank',
                  icon: Icons.quiz_outlined,
                  selectedIcon: Icons.quiz,
                  badge: 'NEW',
                ),
                CustomNavigationRailDestination(
                  label: 'Leaderboard',
                  icon: Icons.leaderboard_outlined,
                  selectedIcon: Icons.leaderboard,
                ),
                CustomNavigationRailDestination(
                  label: 'Profile',
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                ),
                CustomNavigationRailDestination(
                  label: 'Settings',
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                ),
              ],
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.desktop_windows,
                              size: constraints.maxWidth < 400 ? 48 : 72,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Selected Index: $_selectedIndex',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 420),
                              child: const Text(
                                'Toggle the arrow button to preview the collapsed and extended navigation rail.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadioPreview extends StatefulWidget {
  const RadioPreview({super.key});

  @override
  State<RadioPreview> createState() => _RadioPreviewState();
}

class _RadioPreviewState extends State<RadioPreview> {
  String _selectedValue = 'BCS';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomRadio<String>(
            value: 'BCS',
            groupValue: _selectedValue,
            title: 'BCS',
            subtitle: 'Bangladesh Civil Service',
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomRadio<String>(
            value: 'Bank',
            groupValue: _selectedValue,
            title: 'Bank',
            subtitle: 'Bank Recruitment',
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomRadio<String>(
            value: 'Primary',
            groupValue: _selectedValue,
            title: 'Primary Teacher',
            subtitle: 'Government Primary School',
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class SearchFieldPreview extends StatefulWidget {
  const SearchFieldPreview({super.key});

  @override
  State<SearchFieldPreview> createState() => _SearchFieldPreviewState();
}

class _SearchFieldPreviewState extends State<SearchFieldPreview> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSearchField(
            controller: controller,
            hintText: 'Search questions...',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(controller.text.isEmpty ? 'Nothing typed yet' : controller.text),
        ],
      ),
    );
  }
}

class SliderPreview extends StatefulWidget {
  const SliderPreview({super.key});

  @override
  State<SliderPreview> createState() => _SliderPreviewState();
}

class _SliderPreviewState extends State<SliderPreview> {
  double _value = 60;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      child: CustomSlider(
        value: _value,
        min: 0,
        max: 100,
        divisions: 10,
        title: 'Study Progress',
        subtitle: 'Adjust your daily target',
        leading: const Icon(Icons.trending_up),
        valueFormatter: (value) => '${value.toInt()}%',
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
      ),
    );
  }
}
