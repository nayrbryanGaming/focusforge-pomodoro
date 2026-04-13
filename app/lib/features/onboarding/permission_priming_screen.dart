import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/notification_service.dart';
import '../../main.dart';
import 'package:animate_do/animate_do.dart';

class PermissionPrimingScreen extends StatefulWidget {
  const PermissionPrimingScreen({super.key});

  @override
  State<PermissionPrimingScreen> createState() => _PermissionPrimingScreenState();
}

class _PermissionPrimingScreenState extends State<PermissionPrimingScreen> {
  bool _isProcessing = false;

  Future<void> _handlePermissions() async {
    setState(() => _isProcessing = true);
    
    // Request notification permission
    await notificationServiceProvider.requestPermissions();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              FadeInDown(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_active_outlined,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 48),
              
              FadeInUp(
                child: const Text(
                  'Enable Focus Alerts',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 16),
              
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  'FocusForge needs notification access to alert you when your focus sessions and breaks are complete.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const Spacer(),
              
              const _FeatureRow(
                icon: Icons.alarm_on,
                text: 'High-priority Alarms for Breaks',
              ),
              const SizedBox(height: 16),
              const _FeatureRow(
                icon: Icons.timer,
                text: 'Background Timer Persistance',
              ),
              
              const Spacer(),
              
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _handlePermissions,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isProcessing 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Allow Focus Alerts',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              FadeIn(
                delay: const Duration(milliseconds: 600),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                    );
                  },
                  child: const Text(
                    'Maybe Later',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.success),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
