import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/toast_service.dart';
import '../../features/auth/auth_screen.dart';
import 'policy_viewer.dart';
import 'settings_screen.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        ? 'Guest Mode — No account required'
        : (user?.email ?? 'Unknown');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile Forge'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            // ── Avatar Section ──────────────────────────────────────
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isGuest
                    ? const LinearGradient(
                        colors: [Colors.grey, Color(0xFF4A4A6A)],
                      )
                    : const LinearGradient(
                        colors: [AppColors.primary, Color(0xFFFF8C42)],
                      ),
                boxShadow: isGuest
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        )
                      ],
              ),
              child: Center(
                child: Icon(
                  isGuest ? Icons.person_outline : Icons.person,
                  size: 52,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              displayEmail,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: isGuest
                    ? Colors.orange.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isGuest
                      ? Colors.orange.withOpacity(0.3)
                      : AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Text(
                isGuest ? '👤 Guest Mode' : '🔥 FocusForge Member',
                style: TextStyle(
                  color: isGuest ? Colors.orange : AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // ── Guest upgrade CTA ────────────────────────────────────
            if (isGuest) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.25),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.cloud_off, color: AppColors.primary, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Create a free account to sync your data across devices.',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AuthScreen()),
                          ),
                          icon: const Icon(Icons.person_add, size: 18),
                          label: const Text('Create Free Account'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // ── Legal Section ────────────────────────────────────────
            _buildSectionTitle('LEGAL & TRANSPARENCY'),
            _buildListTile(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => _openPolicy(context, 'Privacy Policy',
                  'legal/privacy_policy.md'),
            ),
            _buildListTile(
              context,
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () => _openPolicy(context, 'Terms of Service',
                  'legal/terms_of_service.md'),
            ),
            _buildListTile(
              context,
              icon: Icons.info_outline,
              title: 'Data Usage Policy',
              onTap: () =>
                  _openPolicy(context, 'Data Usage', 'legal/data_usage_policy.md'),
            ),

            const SizedBox(height: 24),

            // ── Support Section ──────────────────────────────────────
            _buildSectionTitle('SUPPORT'),
            _buildListTile(
              context,
              icon: Icons.mail_outline,
              title: 'Contact Support',
              subtitle: 'support@focusforge.app',
              onTap: () => _sendSupportEmail(),
            ),
            _buildListTile(
              context,
              icon: Icons.star_rate_outlined,
              title: 'Rate FocusForge',
              subtitle: 'Love the app? Leave us a review!',
              onTap: () => _openStoreListing(),
            ),

            const SizedBox(height: 24),

            // ── Data Portability ─────────────────────────────────────
            _buildSectionTitle('DATA PORTABILITY'),
            _buildListTile(
              context,
              icon: Icons.download_for_offline_outlined,
              title: 'Export My Data (JSON)',
              subtitle: 'Download your complete focus history',
              onTap: () => _handleDataExport(context),
            ),

            const SizedBox(height: 24),

            // ── Account Actions ──────────────────────────────────────
            _buildSectionTitle('ACCOUNT'),
            if (isSignedIn && !isGuest) ...[
              _buildListTile(
                context,
                icon: Icons.delete_forever_outlined,
                title: 'Delete My Account',
                subtitle: 'Permanently removes all your data',
                titleColor: Colors.redAccent,
                onTap: () => _showDeleteConfirm(context, ref, isAnonymous: false),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await authService.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                        );
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.orange),
                    label: const Text('Log Out of Forge',
                        style: TextStyle(color: Colors.orange)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            ] else if (isGuest) ...[
              _buildListTile(
                context,
                icon: Icons.delete_outline,
                title: 'Clear Guest Data',
                subtitle: 'Removes all local data from this device',
                titleColor: Colors.redAccent,
                onTap: () => _showDeleteConfirm(context, ref, isAnonymous: true),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Sign In / Register',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],

            const SizedBox(height: 48),

            // App version footer
            Text(
              'FocusForge v1.0.0 • Made with ⚡ & ❤️',
              style: TextStyle(
                color: Colors.white.withOpacity(0.15),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 6),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (titleColor ?? Colors.white).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: titleColor ?? Colors.white70, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12),
            )
          : null,
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.textSecondary, size: 18),
      onTap: onTap,
    );
  }

  void _openPolicy(BuildContext context, String title, String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PolicyViewer(title: title, filePath: path),
      ),
    );
  }

  Future<void> _sendSupportEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@focusforge.app',
      query: 'subject=FocusForge Support Request&body=Hello FocusForge team,\n\n',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openStoreListing() async {
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.focusforge.pomodoro',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _handleDataExport(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparing your data archive...')),
    );

    await Future.delayed(const Duration(seconds: 1));

    final exportData = {
      'export_date': DateTime.now().toIso8601String(),
      'app_version': '1.0.0',
      'note': 'This is a summary of your FocusForge productivity data.',
      'data_categories': [
        'Focus sessions (date, duration, task)',
        'Task list (title, estimated/completed pomodoros)',
        'Daily statistics (streak, total hours)',
        'Achievement progress',
      ],
    };

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1A2035),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Data Archive Ready',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your data includes:',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              ...exportData['data_categories']! .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ',
                          style: TextStyle(color: AppColors.primary)),
                      Expanded(
                        child: Text(item as String,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Full data export to file will be available in a future update.',
                style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close',
                  style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      );
    }
  }

  void _showDeleteConfirm(BuildContext context, WidgetRef ref,
      {required bool isAnonymous}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A2035),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isAnonymous ? 'Clear Guest Data?' : '⚠️ Delete Account?',
          style: const TextStyle(
              color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAnonymous
                  ? 'This will permanently delete all local guest data:'
                  : 'This will permanently delete your account and all associated data:',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 14),
            ...const [
              '🗑️ All focus session history',
              '🗑️ All tasks and progress',
              '🗑️ All achievements and streaks',
              '🗑️ Your stats and analytics',
              '🗑️ Your account credentials',
            ].map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(text,
                    style: const TextStyle(color: Colors.white60, fontSize: 13)),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This action CANNOT be undone.',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep My Data'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              if (isAnonymous) {
                _deleteAnonymous(context, ref);
              } else {
                _showReAuthDialog(context, ref);
              }
            },
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAnonymous(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authServiceProvider).deleteAnonymousAccount();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
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
            backgroundColor: const Color(0xFF1A2035),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Confirm Identity',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Please re-enter your credentials to confirm permanent deletion.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed:
                    isLoading ? null : () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);
                        try {
                          await ref
                              .read(authServiceProvider)
                              .reauthenticateAndDelete(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => const AuthScreen()),
                            );
                          }
                        } catch (e) {
                          setState(() => isLoading = false);
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Authentication failed: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Permanently Delete'),
              ),
            ],
          );
        },
      ),
    );
  }
}
