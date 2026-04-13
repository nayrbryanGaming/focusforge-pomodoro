import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/timer_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(statsStreamProvider);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics Forge'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: statsAsync.when(
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('CONSISTENCY HEATMAP'),
              const SizedBox(height: 16),
              _buildFocusHeatmap(context),
              
              const SizedBox(height: 32),
              _buildSectionTitle('WEEKLY FOCUS (HOURS)'),
              const SizedBox(height: 16),
              _buildWeeklyChart(context, primaryColor),
              
              const SizedBox(height: 32),
              _buildSectionTitle('PRODUCTIVITY METRICS'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildMetricCard('Focus Time', '${(stats.totalFocusTime / 3600).toStringAsFixed(1)}h', Icons.timer, primaryColor, 400)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMetricCard('Points', '${stats.totalPoints}', Icons.bolt, theme.colorScheme.secondary, 500)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildMetricCard('Streak', '${stats.dailyStreak} Days', Icons.local_fire_department, Colors.orange, 600)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMetricCard('Level', '${stats.level}', Icons.grade, AppColors.success, 700)),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildFocusHeatmap(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Focus Intensity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Last 30 Days', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: 28, // 4 weeks
            itemBuilder: (context, index) {
              final val = Random(index).nextDouble();
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(val < 0.2 ? 0.05 : val),
                  borderRadius: BorderRadius.circular(4),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: index * 10));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, Color primaryColor) {
    return Container(
      height: 220,
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 8,
          barGroups: List.generate(7, (i) => _buildBarGroup(i, (i + 3) % 8 + 1, primaryColor, isToday: i == 6)),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(days[value.toInt()], style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
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
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color, {bool isToday = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isToday ? color : color.withOpacity(0.4),
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, int delayMs) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delayMs)).scale();
  }
}
