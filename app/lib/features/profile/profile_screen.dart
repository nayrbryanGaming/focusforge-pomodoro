import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

import '../../core/constants/app_colors.dart';
import '../../core/services/l10n_service.dart';
import '../../core/services/database_service.dart';
import '../../core/constants/legal_docs.dart';
import 'policy_viewer.dart';
import 'settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = ref.watch(l10nServiceProvider.notifier);
    
    final String displayName = l10n.translate('master_forger');
    final String displayEmail = l10n.translate('offline_storage');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.translate('profile'), style: const TextStyle(fontWeight: FontWeight.bold)),
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
            _buildProfileHeader(displayName, displayEmail),
            const SizedBox(height: 32),
            _buildSection(context, l10n.translate('achievements').toUpperCase(), [
              _ProfileTile(
                icon: Icons.emoji_events_outlined,
                title: l10n.translate('achievements'),
                onTap: () {
                  // Navigate to achievements or show toast
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.translate('achievements_active'))),
                  );
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, l10n.translate('legal_compliance'), [
              _ProfileTile(
                icon: Icons.privacy_tip_outlined,
                title: l10n.translate('privacy_policy'),
                onTap: () => _openPolicy(context, l10n.translate('privacy_policy'), LegalDocs.privacyPolicy),
              ),
              _ProfileTile(
                icon: Icons.description_outlined,
                title: l10n.translate('terms_of_service'),
                onTap: () => _openPolicy(context, l10n.translate('terms_of_service'), LegalDocs.termsOfService),
              ),
              _ProfileTile(
                icon: Icons.verified_user_outlined,
                title: l10n.translate('data_usage_policy'),
                onTap: () => _openPolicy(context, l10n.translate('data_usage_policy'), LegalDocs.dataUsagePolicy),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, l10n.translate('account_actions'), [
              _ProfileTile(
                icon: Icons.delete_outline_rounded,
                title: l10n.translate('wipe_data'),
                titleColor: Colors.redAccent,
                onTap: () => _showWipeConfirmation(context, ref, l10n),
              ),
            ]),
            const SizedBox(height: 48),
            const Text(
              'FocusForge v1.3.1 • 100% Offline Stable Version',
              style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFFFF8C42)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 4),
          ),
          child: const Center(
            child: Icon(
              Icons.person_rounded,
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

  void _showWipeConfirmation(BuildContext context, WidgetRef ref, L10nService l10n) {
    final textController = TextEditingController();
    bool canDelete = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            title: Text(l10n.translate('purge_confirm_title'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate('purge_confirm_body'),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.translate('purge_confirm_input'),
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
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.translate('keep_working'))),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: ElevatedButton(
                  onPressed: canDelete
                      ? () async {
                          Navigator.pop(ctx);
                          await databaseService.clearAllData();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.translate('data_purged'))),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    disabledBackgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(l10n.translate('purge_button')),
                ),
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
              const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
