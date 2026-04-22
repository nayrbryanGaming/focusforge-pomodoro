import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

import '../../core/constants/app_colors.dart';
import '../../core/services/stats_service.dart';
import '../../providers/timer_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(statsStreamProvider);
    final intensityAsync = ref.watch(focusIntensityProvider);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Statistics Forge', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: statsAsync.when(
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressOverview(theme, stats),
              const SizedBox(height: 32),
              _buildSectionHeader('CONSISTENCY HEATMAP', Icons.grid_view_rounded),
              const SizedBox(height: 16),
              _buildFocusHeatmap(context, ref),
              const SizedBox(height: 32),
              _buildSectionHeader('WEEKLY FOCUS INTENSITY', Icons.bar_chart_rounded),
              const SizedBox(height: 16),
              intensityAsync.when(
                data: (intensity) => _buildWeeklyChart(context, primaryColor, intensity),
                loading: () => _buildChartLoader(),
                error: (_, __) => _buildChartError(),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader('PRODUCTIVITY METRICS', Icons.insights_rounded),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildMetricCard(
                    'Focus Time', 
                    '${(stats.totalFocusTime / 3600).toStringAsFixed(1)}h', 
                    Icons.timer_outlined, 
                    primaryColor, 
                    400
                  ),
                  _buildMetricCard(
                    'Forge Points', 
                    '${stats.totalPoints}', 
                    Icons.bolt, 
                    const Color(0xFFFFD166), 
                    500
                  ),
                  _buildMetricCard(
                    'Current Streak', 
                    '${stats.dailyStreak} Days', 
                    Icons.local_fire_department_rounded, 
                    Colors.orangeAccent, 
                    600
                  ),
                  _buildMetricCard(
                    'Forge Level', 
                    'Level ${stats.level}', 
                    Icons.military_tech_outlined, 
                    AppColors.success, 
                    700
                  ),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressOverview(ThemeData theme, dynamic stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.25),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stats.level > 10 ? 'Grandmaster Forge' : 'Apprentice Forger',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rank: ${stats.level > 20 ? 'Mythic Vanguard' : 'Focus Aspirant'}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: const Icon(Icons.shield_rounded, color: AppColors.accent, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSimpleStat('Sessions', stats.totalSessions.toString()),
              _buildSimpleStat('Completed', stats.completedTasks.toString()),
              _buildSimpleStat('Forge Level', stats.level.toString()),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildSimpleStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFocusHeatmap(BuildContext context, WidgetRef ref) {
    final intensityAsync = ref.watch(focusIntensityProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              intensityAsync.when(
                data: (intensity) => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: 28,
                  itemBuilder: (context, index) {
                    final val = intensity[index] ?? 0.0;
                    final color = val < 0.05 
                        ? Colors.white.withValues(alpha: 0.03)
                        : AppColors.primary.withValues(alpha: (0.1 + (val * 0.9)).clamp(0.0, 1.0));
                    
                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: val > 0.6 ? [
                          BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 4)
                        ] : [],
                      ),
                    ).animate().scale(delay: (index * 10).ms, duration: 300.ms);
                  },
                ),
                loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox(height: 120),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Less Focus', style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                  Row(
                    children: List.generate(5, (i) => Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: (0.1 + (i * 0.225)).clamp(0.0, 1.0)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )),
                  ),
                  const Text('Master Focus', style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, Color primaryColor, Map<int, double> intensity) {
    return Container(
      height: 280,
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 8,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: const Color(0xFF161B2E),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.toStringAsFixed(1)}h',
                    TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 14),
                  );
                },
              ),
            ),
            barGroups: List.generate(7, (i) {
              final hours = (intensity[21 + i] ?? 0.0) * 8; 
              return _buildBarGroup(i, hours, primaryColor, isToday: i == 6);
            }),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
                    final isToday = value.toInt() == 6;
                    return Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Text(
                        days[value.toInt() % 7],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: isToday ? primaryColor : AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, curve: Curves.easeOut);
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color, {bool isToday = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: isToday 
                ? [color, color.withValues(alpha: 0.7)] 
                : [Colors.white.withValues(alpha: 0.05), Colors.white.withValues(alpha: 0.15)],
          ),
          width: 14,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 8,
            color: Colors.white.withValues(alpha: 0.02),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, int delayMs) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delayMs.ms).moveY(begin: 20, end: 0, delay: delayMs.ms);
  }

  Widget _buildChartLoader() => const SizedBox(height: 240, child: Center(child: CircularProgressIndicator()));
  Widget _buildChartError() => const SizedBox(height: 240, child: Center(child: Icon(Icons.error_outline, color: Colors.white24)));
}
