import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/toast_service.dart';
import '../../features/auth/auth_screen.dart';
import '../../core/constants/legal_docs.dart';
import 'policy_viewer.dart';
import 'settings_screen.dart';
import 'premium_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authService = ref.read(authServiceProvider);
    final user = authService.currentUser;
    final isGuest = user?.isAnonymous ?? true;
    final isSignedIn = user != null;

    final String displayName = isGuest
        ? 'Guest Forger'
        : (user?.displayName?.isNotEmpty == true
            ? user!.displayName!
            : user?.email?.split('@').first ?? 'Forger');

    final String displayEmail = isGuest
        ? 'Guest Mode — Local Storage'
        : (user?.email ?? 'Unknown');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile Forge', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            _buildProfileHeader(isGuest, displayName, displayEmail),
            const SizedBox(height: 24),
            _buildPremiumCTA(context),
            const SizedBox(height: 32),
            _buildSection(context, 'LEGAL & COMPLIANCE', [
              _ProfileTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () => _openPolicy(context, 'Privacy Policy', LegalDocs.privacyPolicy),
              ),
              _ProfileTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () => _openPolicy(context, 'Terms of Service', LegalDocs.termsOfService),
              ),
              _ProfileTile(
                icon: Icons.verified_user_outlined,
                title: 'Data Usage Policy',
                onTap: () => _openPolicy(context, 'Data Usage', LegalDocs.dataUsagePolicy),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'SUPPORT', [
              _ProfileTile(
                icon: Icons.alternate_email_rounded,
                title: 'Contact Support',
                onTap: () => _sendSupportEmail(),
              ),
              _ProfileTile(
                icon: Icons.star_outline_rounded,
                title: 'Rate on Play Store',
                onTap: () => _openStoreListing(),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'ACCOUNT ACTIONS', [
              if (isSignedIn && !isGuest) ...[
                _ProfileTile(
                  icon: Icons.delete_forever_outlined,
                  title: 'Delete My Account',
                  titleColor: Colors.redAccent,
                  onTap: () => _showDeleteConfirmation(context, ref, false),
                ),
                _ProfileTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  onTap: () async {
                    await authService.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const AuthScreen()),
                      );
                    }
                  },
                ),
              ] else if (isGuest) ...[
                _ProfileTile(
                  icon: Icons.person_add_outlined,
                  title: 'Create Account',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  ),
                ),
                _ProfileTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'Wipe Local Data',
                  titleColor: Colors.redAccent,
                  onTap: () => _showDeleteConfirmation(context, ref, true),
                ),
              ],
            ]),
            const SizedBox(height: 48),
            const Text(
              'FocusForge v1.3.1 • 18th Submission Forge',
              style: TextStyle(color: Colors.white12, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isGuest, String name, String email) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isGuest 
                ? [Colors.grey.shade800, Colors.grey.shade900]
                : [AppColors.primary, const Color(0xFFFF8C42)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: (isGuest ? Colors.black : AppColors.primary).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 4),
          ),
          child: Center(
            child: Icon(
              isGuest ? Icons.person_outline : Icons.person_rounded,
              size: 52,
              color: Colors.white,
            ),
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
        const SizedBox(height: 20),
        Text(
          name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Text(
            email,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumCTA(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 12))
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FORGE PRO', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    Text('Cloud sync, custom sounds & detailed insights', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white60),
            ],
          ),
        ),
      ),
    ).animate().shimmer(delay: 2.seconds, duration: 1500.ms);
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1.5),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Column(children: children),
            ),
          ),
        ),
      ],
    );
  }

  void _openPolicy(BuildContext context, String title, String contentData) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PolicyViewer(title: title, contentData: contentData)));
  }

  Future<void> _sendSupportEmail() async {
    final uri = Uri(scheme: 'mailto', path: 'support@focusforge.app', query: 'subject=FocusForge%20Support');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openStoreListing() async {
    final uri = Uri.parse('https://play.google.com/store/apps/details?id=com.focusforge.pomodoro');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, bool isAnonymous) {
    final textController = TextEditingController();
    bool canDelete = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1A1F36),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            title: const Text('PURGE DATA?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This action is IRREVERSIBLE. All focus history, points, and tasks will be permanently wiped.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),
                Text(
                  'Type "DELETE" to confirm:',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: textController,
                  onChanged: (val) {
                    setDialogState(() => canDelete = val == 'DELETE');
                  },
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'DELETE',
                    hintStyle: const TextStyle(color: Colors.white10),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () => launchUrl(Uri.parse('https://focusforge.app/deletion')),
                    icon: const Icon(Icons.open_in_new_sharp, size: 14),
                    label: const Text('Web Deletion Portal', style: TextStyle(fontSize: 11)),
                    style: TextButton.styleFrom(foregroundColor: Colors.white24),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep Working')),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: ElevatedButton(
                  onPressed: canDelete
                      ? () {
                          Navigator.pop(ctx);
                          if (isAnonymous) {
                            ref.read(authServiceProvider).deleteAnonymousAccount();
                          } else {
                            _showReAuthDialog(context, ref);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    disabledBackgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('PURGE EVERYTHING'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showReAuthDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          bool isLoading = false;
          return AlertDialog(
            backgroundColor: const Color(0xFF1A1F36),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            title: const Text('Confirm Identity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Please re-enter your credentials to authorize permanent deletion.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white30),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white30),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: isLoading ? null : () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);
                        try {
                          await ref.read(authServiceProvider).reauthenticateAndDelete(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const AuthScreen()),
                            );
                          }
                        } catch (e) {
                          setState(() => isLoading = false);
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text('Verification failed: $e'), backgroundColor: Colors.red),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Confirm Purge'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;

  const _ProfileTile({required this.icon, required this.title, required this.onTap, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (titleColor ?? Colors.white).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: titleColor ?? Colors.white70),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor ?? Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
