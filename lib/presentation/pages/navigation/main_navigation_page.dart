import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart' as di;
import '../../../l10n/app_localizations.dart';
import '../../bloc/video/video_bloc.dart';
import '../../bloc/video/video_event.dart';
import '../../bloc/premium/premium_bloc.dart';
import '../../courses/bloc/courses_bloc.dart';
import '../../courses/bloc/courses_event.dart';
import '../home/home_page.dart';
import '../practice/practice_page.dart';
import '../../courses/pages/courses_page.dart';
import '../settings/settings_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  List<NavigationItem> _getNavigationItems(BuildContext context) {
    return [
      NavigationItem(
        icon: Icons.home,
        label: AppLocalizations.of(context)?.home ?? 'Home',
        page: const HomePage(),
      ),
      NavigationItem(
        icon: Icons.self_improvement,
        label: AppLocalizations.of(context)?.practice ?? 'Practice',
        page: const PracticePage(),
      ),
      NavigationItem(
        icon: Icons.school,
        label: AppLocalizations.of(context)?.courses ?? 'Courses',
        page: const CoursesPage(),
      ),
      NavigationItem(
        icon: Icons.settings,
        label: AppLocalizations.of(context)?.settings ?? 'Settings',
        page: const SettingsPage(),
      ),
    ];
  }


  void _onTabTapped(BuildContext blocContext, int index) {
    // Refresh data when switching tabs
    if (index == 0) {
      // Home tab: reload selected course and videos
      blocContext.read<CoursesBloc>().add(const LoadSelectedCourse());
      blocContext.read<VideoBloc>().add(const LoadVideos());
    } else if (index == 2) {
      // Courses tab: ensure courses list is loaded
      blocContext.read<CoursesBloc>().add(const LoadCourses());
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationItems = _getNavigationItems(context);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<VideoBloc>(
          create: (context) => di.sl<VideoBloc>(),
        ),
        BlocProvider<PremiumBloc>(
          create: (context) => di.sl<PremiumBloc>(),
        ),
        BlocProvider<CoursesBloc>(
          create: (context) => di.sl<CoursesBloc>(),
        ),
      ],
      child: Builder(
        builder: (blocContext) {
          // Determine status bar style based on theme brightness
          final brightness = Theme.of(blocContext).brightness;
          final systemUiOverlayStyle = brightness == Brightness.dark
              ? SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: Theme.of(blocContext).colorScheme.surface,
                )
              : SystemUiOverlayStyle.dark.copyWith(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: Theme.of(blocContext).colorScheme.surface,
                );

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: systemUiOverlayStyle,
            child: Scaffold(
              extendBody: true,
              body: IndexedStack(
                index: _currentIndex,
                children: navigationItems.asMap().entries.map((entry) {
                  return KeyedSubtree(
                    key: ValueKey('page_${entry.key}'),
                    child: entry.value.page,
                  );
                }).toList(),
              ),
              bottomNavigationBar: _buildBottomNavigationBar(blocContext, navigationItems),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext blocContext, List<NavigationItem> navigationItems) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Colors.white.withValues(alpha: 0.12),
                          Colors.white.withValues(alpha: 0.06),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.95),
                          Colors.white.withValues(alpha: 0.85),
                        ],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : theme.colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: navigationItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = _currentIndex == index;

                  return GestureDetector(
                    onTap: () => _onTabTapped(blocContext, index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 12 : 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.colorScheme.primary.withValues(alpha: 0.2),
                                  theme.colorScheme.primary.withValues(alpha: 0.1),
                                ],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withValues(alpha: 0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              item.icon,
                              size: isSelected ? 20 : 24,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            child: isSelected
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      item.label,
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Widget page;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.page,
  });
}