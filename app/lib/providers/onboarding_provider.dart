import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  // This will be initialized with the value from SharedPreferences
  throw UnimplementedError();
});

class OnboardingNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const String _kOnboardingDone = 'onboarding_complete_v2';

  OnboardingNotifier(this._prefs) : super(_prefs.getBool(_kOnboardingDone) ?? false);

  Future<void> completeOnboarding() async {
    await _prefs.setBool(_kOnboardingDone, true);
    state = true;
  }
}
