import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUser {
  final String uid;
  final String? email;
  final String displayName;

  LocalUser({
    required this.uid,
    this.email,
    required this.displayName,
  });
}

class AuthService {
  final Ref _ref;
  LocalUser? _currentUser;

  AuthService(this._ref) {
    _loadUser();
  }

  LocalUser? get currentUser => _currentUser;

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('local_uid') ?? 'forger_${DateTime.now().millisecondsSinceEpoch}';
    if (!prefs.containsKey('local_uid')) {
      await prefs.setString('local_uid', uid);
    }
    
    _currentUser = LocalUser(
      uid: uid,
      displayName: 'Focus Forger',
      email: 'offline@focusforge.local',
    );
  }

  Future<void> initializeLocalSession() async {
    // 100% Offline: Local session initialized automatically
    await _loadUser();
  }

  Future<void> resetSession() async {
    // Reset local session state
    _currentUser = null;
  }
}

final authServiceProvider = Provider((ref) => AuthService(ref));
