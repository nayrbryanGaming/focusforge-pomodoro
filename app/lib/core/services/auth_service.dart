import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool get isGuest => _auth.currentUser?.isAnonymous ?? true;
  bool get isSignedIn => _auth.currentUser != null;

  /// Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
    // If currently anonymous, link rather than create a new session
    // This preserves any local session data
    final current = _auth.currentUser;
    if (current != null && current.isAnonymous) {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      try {
        return await current.linkWithCredential(credential);
      } catch (_) {
        // If linking fails, sign in normally
      }
    }
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Sign up with email and password
  Future<UserCredential?> signUp(String email, String password) async {
    final current = _auth.currentUser;
    if (current != null && current.isAnonymous) {
      // Upgrade anonymous account to permanent
      final credential = EmailAuthProvider.credential(email: email, password: password);
      return await current.linkWithCredential(credential);
    }
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  /// Sign in anonymously for guest access
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> reauthenticateAndDelete(String email, String password) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 1. Re-authenticate to confirm identity
      final AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(credential);

      // 2. Purge all Firestore data first
      await firestoreService.purgeUserData(user.uid);

      // 3. Delete the Firebase Auth account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        rethrow;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete anonymous (guest) account and all its data
  Future<void> deleteAnonymousAccount() async {
    final user = _auth.currentUser;
    if (user == null || !user.isAnonymous) return;
    await firestoreService.purgeUserData(user.uid);
    await user.delete();
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
