// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  // final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    debugPrint('📊 Analytics Event: $name | Params: $parameters');
    // await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logSessionStarted(int duration) async {
    await logEvent('focus_session_started', parameters: {'duration': duration});
  }

  Future<void> logTaskCompleted(String category) async {
    await logEvent('task_completed', parameters: {'category': category});
  }

  Future<void> logAchievementUnlocked(String title) async {
    await logEvent('achievement_unlocked', parameters: {'title': title});
  }

  Future<void> logOnboardingComplete() async {
    await logEvent('onboarding_complete');
  }
}

final analyticsService = AnalyticsService();
