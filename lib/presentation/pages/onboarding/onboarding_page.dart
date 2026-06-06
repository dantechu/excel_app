import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart' as di;
import '../../../data/datasources/onboarding_local_datasource.dart';
import '../../courses/bloc/courses_bloc.dart';
import '../../courses/bloc/courses_event.dart';
import '../../courses/bloc/courses_state.dart';
import '../../courses/widgets/course_card.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final datasource = di.sl<OnboardingLocalDataSource>();
    await datasource.setFirstTimeFalse();

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _WelcomeScreen(
                onNext: _nextPage,
                onSkip: _completeOnboarding,
                floatingController: _floatingController,
              ),
              _CourseSelectionScreen(onComplete: _completeOnboarding),
            ],
          ),

          // Page Indicator
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final AnimationController floatingController;

  const _WelcomeScreen({
    required this.onNext,
    required this.onSkip,
    required this.floatingController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Animated Background
        Positioned.fill(
          child: CustomPaint(
            painter: FloatingShapesPainter(
              animation: floatingController,
              color: theme.colorScheme.primary,
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
                theme.colorScheme.surface.withValues(alpha: 0.95),
                theme.colorScheme.surface,
              ],
            ),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: onSkip,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Animated Icon
                AnimatedBuilder(
                  animation: floatingController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 8 * math.sin(floatingController.value * 2 * math.pi)),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.grid_on_rounded,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                Text(
                  'Master Excel',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Learn Excel from beginner to advanced with step-by-step video tutorials. Build essential spreadsheet skills for work and life.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 32),

                // Feature highlights
                _FeatureItem(
                  icon: Icons.play_circle_outline,
                  text: 'HD Video Tutorials',
                  theme: theme,
                ),
                const SizedBox(height: 12),
                _FeatureItem(
                  icon: Icons.school_outlined,
                  text: 'Structured Courses',
                  theme: theme,
                ),
                const SizedBox(height: 12),
                _FeatureItem(
                  icon: Icons.trending_up,
                  text: 'Beginner to Advanced',
                  theme: theme,
                ),

                const Spacer(flex: 2),

                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onNext,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final ThemeData theme;

  const _FeatureItem({
    required this.icon,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _CourseSelectionScreen extends StatelessWidget {
  final VoidCallback onComplete;

  const _CourseSelectionScreen({
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => di.sl<CoursesBloc>()..add(const LoadCourses()),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: onComplete,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Choose Your Course',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      'Select an Excel course to start learning. You can change this anytime in settings.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Courses List
              Expanded(
                child: BlocBuilder<CoursesBloc, CoursesState>(
                  builder: (context, state) {
                    if (state is CoursesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is CoursesError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 48,
                                color: theme.colorScheme.error.withValues(alpha: 0.7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Unable to load courses',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.message,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is CoursesLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: state.courses.length,
                        itemBuilder: (context, index) {
                          final course = state.courses[index];
                          final isSelected = state.selectedCourse?.id == course.id;

                          return CourseCard(
                            course: course,
                            isSelected: isSelected,
                            onTap: () {
                              context.read<CoursesBloc>().add(SelectCourseEvent(course.id));
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Get Started Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onComplete,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text(
                      'Start Learning',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Animated Background

class FloatingShapesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  FloatingShapesPainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    final animValue = animation.value;

    // Floating shapes representing spreadsheet cells
    _drawRoundedRect(canvas, paint, size, 0.15, 0.25, 60, 40, animValue);
    _drawRoundedRect(canvas, paint, size, 0.8, 0.35, 50, 35, animValue + 0.3);
    _drawRoundedRect(canvas, paint, size, 0.3, 0.7, 70, 45, animValue + 0.6);
    _drawRoundedRect(canvas, paint, size, 0.75, 0.65, 55, 38, animValue + 0.9);
  }

  void _drawRoundedRect(Canvas canvas, Paint paint, Size size,
      double xRatio, double yRatio, double width, double height, double animOffset) {
    final x = size.width * xRatio;
    final y = size.height * yRatio + (20 * math.sin((animOffset) * 2 * math.pi));

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(x, y), width: width, height: height),
      const Radius.circular(8),
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
