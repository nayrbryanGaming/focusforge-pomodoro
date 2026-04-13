import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  final InAppReview _inAppReview = InAppReview.instance;
  final SharedPreferences _prefs;

  ReviewService(this._prefs);

  static const String _sessionCountKey = 'sessions_completed_for_review';
  static const String _hasReviewedKey = 'has_prompted_for_review';

  Future<void> incrementSessionAndCheck() async {
    if (_prefs.getBool(_hasReviewedKey) ?? false) return;

    int sessions = _prefs.getInt(_sessionCountKey) ?? 0;
    sessions++;
    await _prefs.setInt(_sessionCountKey, sessions);

    // Prompt after 3 successful sessions (Value Realization point)
    if (sessions >= 3) {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
        await _prefs.setBool(_hasReviewedKey, true);
      }
    }
  }

  Future<void> openStoreListing() async {
    if (await _inAppReview.isAvailable()) {
      _inAppReview.openStoreListing();
    }
  }
}

final reviewServiceProvider = Provider<ReviewService>((ref) {
  // Overridden in main.dart
  throw UnimplementedError();
});
