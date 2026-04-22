import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/task_model.dart';
import '../../core/services/task_service.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context),
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                border: UnderlineInputBorder(),
              ),
            ).animate().fadeIn().moveX(begin: -20, end: 0),
            
            const SizedBox(height: 32),
            _buildStatRow('Total Focus Time', '${widget.completed * 25}m'),
            _buildStatRow('Sessions Completed', '${widget.completed} / $_estimated'),
            _buildStatRow('Created On', DateFormat('MMM dd, yyyy').format(widget.task.createdAt)),
            _buildStatRow('Category', widget.task.category.name.toUpperCase()),
            
            const SizedBox(height: 32),
            const Text('Estimation', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => setState(() { if (_estimated > 1) _estimated--; }),
                ),
                Text('$_estimated Forge Sessions', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() { if (_estimated < 12) _estimated++; }),
                ),
              ],
            ),

            const SizedBox(height: 48),
            const Text(
              'Session History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.completed == 0)
              const Center(child: Text('No sessions logged yet.', style: TextStyle(color: AppColors.textSecondary)))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.completed,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.check_circle, color: AppColors.success),
                    title: Text('Session ${index + 1}'),
                    subtitle: const Text('25:00 focus completed'),
                    trailing: Text(DateFormat('HH:mm').format(DateTime.now())),
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
            padding: const EdgeInsets.symmetric(vertical: 16),
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
          child: const Text('SAVE MODIFICATIONS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
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
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F36),
        title: const Text('Delete Task?'),
        content: const Text('This will remove the task and all its focus history from the Forge.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await ref.read(taskServiceProvider).deleteTask(widget.taskId);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
