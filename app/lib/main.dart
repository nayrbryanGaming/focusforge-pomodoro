import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'core/theme/app_theme.dart';
import 'features/timer/timer_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/tasks/tasks_screen.dart';
import 'features/stats/stats_screen.dart';
import 'features/profile/profile_screen.dart';
import 'core/services/notification_service.dart';
import 'core/services/toast_service.dart';
import 'core/services/settings_service.dart';
import 'core/services/l10n_service.dart';
import 'core/services/review_service.dart';
import 'core/constants/app_colors.dart';
import 'providers/onboarding_provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize Notification Service
  final container = ProviderContainer(
    overrides: [
      settingsServiceProvider.overrideWith((ref) => SettingsService(prefs)),
      l10nServiceProvider.overrideWith((ref) => L10nService(prefs)),
      reviewServiceProvider.overrideWith((ref) => ReviewService(prefs)),
      onboardingProvider.overrideWith((ref) => OnboardingNotifier(prefs)),
    ],
  );

  try {
    await container.read(notificationServiceProvider).init();
  } catch (e) {
    if (kDebugMode) debugPrint('⚠️ Notifications unavailable: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: FocusForgeApp(prefs: prefs),
    ),
  );
}

class FocusForgeApp extends ConsumerWidget {
  final SharedPreferences prefs;

  const FocusForgeApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedTheme(
      data: AppTheme.getForMode(ref.watch(timerThemeProvider).timerTheme),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'FocusForge',
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: ToastService.messengerKey,
            theme: AppTheme.getForMode(ref.watch(timerThemeProvider).timerTheme),
            home: _RootRouter(prefs: prefs),
          );
        },
      ),
    );
  }
}

class _RootRouter extends ConsumerWidget {
  final SharedPreferences prefs;

  const _RootRouter({required this.prefs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = ref.watch(onboardingProvider);

    if (!isComplete) {
      return OnboardingScreen(onComplete: () {
        ref.read(onboardingProvider.notifier).completeOnboarding();
      });
    }

    // Offline app: Always direct to MainNavigationScreen
    return const MainNavigationScreen();
  }
}

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;
  late ConfettiController _confettiController;

  final _screens = const [
    TimerScreen(),
    TasksScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPowerSaving = ref.watch(settingsServiceProvider).isPowerSavingMode;
    final l10n = ref.watch(l10nServiceProvider.notifier);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            backgroundColor: AppColors.surface,
            elevation: 0,
            indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
              HapticFeedback.selectionClick();
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.timer_outlined),
                selectedIcon: const Icon(Icons.timer),
                label: l10n.translate('timer'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.task_alt_outlined),
                selectedIcon: const Icon(Icons.task_alt),
                label: l10n.translate('tasks'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: l10n.translate('stats'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: l10n.translate('profile'),
              ),
            ],
          ),
        ),

        // Global Confetti Overlay
        if (!isPowerSaving)
          IgnorePointer(
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              colors: const [
                AppColors.primary,
                AppColors.accent,
                AppColors.success,
                Colors.white,
              ],
              pauseEmissionOnLowFrameRate: true,
            ),
          ),
      ],
    );
  }
}
