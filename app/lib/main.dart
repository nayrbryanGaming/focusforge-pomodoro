import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'core/theme/app_theme.dart';
import 'features/timer/timer_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/auth_screen.dart';
import 'features/tasks/tasks_screen.dart';
import 'features/stats/stats_screen.dart';
import 'features/profile/profile_screen.dart';
import 'core/services/notification_service.dart';
import 'core/services/toast_service.dart';
import 'core/services/analytics_service.dart';
import 'core/services/settings_service.dart';
import 'core/services/l10n_service.dart';
import 'core/services/review_service.dart';
import 'core/services/auth_service.dart';
import 'core/constants/app_colors.dart';
// Removed unused timer_provider import

const String _kOnboardingDone = 'onboarding_complete_v2';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    // Set up crash reporting for release builds only
    if (!kDebugMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
    if (kDebugMode) debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    if (kDebugMode) debugPrint('⚠️ Firebase not initialized: $e');
  }

  // Initialize Notification Service
  final container = ProviderContainer();
  try {
    await container.read(notificationServiceProvider).init();
  } catch (e) {
    if (kDebugMode) debugPrint('⚠️ Notifications unavailable: $e');
  }

  // Log app open event
  try {
    await analyticsService.logEvent('app_opened');
  } catch (e) {
    if (kDebugMode) debugPrint('Analytics log skipped: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      overrides: [
        settingsServiceProvider.overrideWith((ref) => SettingsService(prefs)),
        l10nServiceProvider.overrideWith((ref) => L10nService(prefs)),
        reviewServiceProvider.overrideWith((ref) => ReviewService(prefs)),
      ],
      child: FocusForgeApp(prefs: prefs),
    ),
  );
}

class FocusForgeApp extends ConsumerWidget {
  final SharedPreferences prefs;

  const FocusForgeApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerThemeState = ref.watch(timerThemeProvider);

    return AnimatedTheme(
      data: AppTheme.getForMode(timerThemeState.timerTheme),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'FocusForge',
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: ToastService.messengerKey,
            theme: AppTheme.getForMode(timerThemeState.timerTheme),
            home: _RootRouter(prefs: prefs),
          );
        },
      ),
    );
  }
}

/// Smart router that sends users to the right screen based on state:
/// - New user → Onboarding
/// - Returning user, not signed in → AuthScreen
/// - Signed in (guest or full account) → MainNavigationScreen
class _RootRouter extends ConsumerWidget {
  final SharedPreferences prefs;

  const _RootRouter({required this.prefs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSeenOnboarding = prefs.getBool(_kOnboardingDone) ?? false;

    if (!hasSeenOnboarding) {
      return OnboardingScreen(onComplete: () async {
        await prefs.setBool(_kOnboardingDone, true);
      });
    }

    final authService = ref.read(authServiceProvider);
    final user = authService.currentUser;

    if (user != null) {
      // Already signed in (anonymous or full account)
      return const MainNavigationScreen();
    }

    // Not signed in — show auth
    return const AuthScreen();
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
              analyticsService.logEvent('tab_switched', parameters: {'index': index});
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
          ConfettiWidget(
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
      ],
    );
  }
}
