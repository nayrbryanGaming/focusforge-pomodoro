import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskId;
  final String initialTitle;
  final int estimated;
  final int completed;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
    required this.initialTitle,
    required this.estimated,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
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
              initialValue: initialTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: InputBorder.none,
              ),
            ).animate().fadeIn().moveX(begin: -20, end: 0),
            
            const SizedBox(height: 32),
            _buildStatRow('Total Focus Time', '2h 15m'),
            _buildStatRow('Sessions Completed', '$completed / $estimated'),
            _buildStatRow('Created On', 'April 11, 2026'),
            
            const SizedBox(height: 48),
            const Text(
              'Session History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: completed,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: AppColors.success),
                  title: Text('Session ${index + 1}'),
                  subtitle: const Text('25:00 completed'),
                  trailing: const Text('Today'),
                ).animate().fadeIn(delay: Duration(milliseconds: index * 100));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Save Changes'),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: const Text('This will remove the task and all its focus history.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
