import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/task_model.dart';
import '../../core/services/task_service.dart';
import '../../core/services/l10n_service.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  final String taskId;
  final String initialTitle;
  final int estimated;
  final int completed;
  final TaskModel task;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
    required this.initialTitle,
    required this.estimated,
    required this.completed,
    required this.task,
  });

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  late TextEditingController _titleController;
  late int _estimated;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _estimated = widget.estimated;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(l10nServiceProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('task_details'), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context, l10n),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
              decoration: InputDecoration(
                labelText: l10n.translate('task_title'),
                labelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                border: const UnderlineInputBorder(),
              ),
            ).animate().fadeIn().moveX(begin: -20, end: 0),
            
            const SizedBox(height: 32),
            _buildStatRow(l10n.translate('total_focus_time'), '${widget.completed * 25}m'),
            _buildStatRow(l10n.translate('sessions_completed'), '${widget.completed} / $_estimated'),
            _buildStatRow(l10n.translate('created_on'), DateFormat('MMM dd, yyyy').format(widget.task.createdAt)),
            _buildStatRow(l10n.translate('category'), widget.task.category.name.toUpperCase()),
            
            const SizedBox(height: 32),
            Text(l10n.translate('estimation'), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
                    onPressed: () => setState(() { if (_estimated > 1) _estimated--; }),
                  ),
                  const SizedBox(width: 12),
                  Text('$_estimated', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
                    onPressed: () => setState(() { if (_estimated < 12) _estimated++; }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
            Text(
              l10n.translate('session_history'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 16),
            if (widget.completed == 0)
              Center(child: Text(l10n.translate('no_sessions_logged'), style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.completed,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle, color: AppColors.success),
                      title: Text('Session ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: const Text('25:00 focus completed', style: TextStyle(color: AppColors.textSecondary)),
                      trailing: Text(DateFormat('HH:mm').format(DateTime.now()), style: const TextStyle(color: Colors.white38)),
                    ),
                  ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () async {
            final updatedTask = widget.task.copyWith(
              title: _titleController.text.trim(),
              estimatedPomodoros: _estimated,
            );
            await ref.read(taskServiceProvider).updateTask(updatedTask);
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(l10n.translate('save_modifications'), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, L10nService l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.translate('delete_task_confirm'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(l10n.translate('delete_task_body'), style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.translate('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () async {
              await ref.read(taskServiceProvider).deleteTask(widget.taskId);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.translate('clear')),
          ),
        ],
      ),
    );
  }
}
