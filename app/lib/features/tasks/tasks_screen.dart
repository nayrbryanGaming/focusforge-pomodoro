import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../models/task_model.dart';
import '../../core/services/task_service.dart';
import 'task_details_screen.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasksAsync = ref.watch(tasksStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Tasks'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () => setState(() => _selectedCategory = null),
            tooltip: 'Clear Filter',
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final filteredTasks = _selectedCategory == null 
              ? tasks 
              : tasks.where((t) => t.category == _selectedCategory).toList();
          final completedCount = tasks.where((t) => t.isCompleted).length;

          return Column(
            children: [
              // Progress Header
              _buildProgressHeader(theme, tasks.length, completedCount),

              // Category Filter Chips
              _buildCategoryChips(theme),

              // Task List
              Expanded(
                child: filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          return _buildTaskCard(filteredTasks[index], index);
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Task', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildProgressHeader(ThemeData theme, int total, int completed) {
    double progress = total == 0 ? 0 : completed / total;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Overall Progress', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    Text('$completed / $total Done', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceHighlight,
                    color: theme.colorScheme.primary,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
          ),
        ],
      ),
    ).animate().fadeIn().moveY(begin: 10, end: 0);
  }

  Widget _buildCategoryChips(ThemeData theme) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _categoryChip(null, 'All', Icons.grid_view, theme),
          _categoryChip(TaskCategory.work, 'Work', Icons.work_outline, theme),
          _categoryChip(TaskCategory.study, 'Study', Icons.school_outlined, theme),
          _categoryChip(TaskCategory.personal, 'Personal', Icons.self_improvement, theme),
          _categoryChip(TaskCategory.other, 'Other', Icons.more_horiz, theme),
        ],
      ),
    );
  }

  Widget _categoryChip(TaskCategory? category, String label, IconData icon, ThemeData theme) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : AppColors.surfaceHighlight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task, int index) {
    final theme = Theme.of(context);
    final Color priorityColor = task.priority == TaskPriority.high
        ? Colors.redAccent
        : task.priority == TaskPriority.medium
            ? AppColors.accent
            : Colors.grey;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskDetailsScreen(
            taskId: task.id,
            initialTitle: task.title,
            estimated: task.estimatedPomodoros,
            completed: task.completedPomodoros,
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: task.isCompleted ? AppColors.success.withOpacity(0.4) : theme.colorScheme.primary.withOpacity(0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Priority indicator
                  Container(width: 4, height: 40, decoration: BoxDecoration(color: priorityColor, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            color: task.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.label_outline, size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              task.category.name.toUpperCase(),
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, letterSpacing: 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Pomodoro count
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Text(
                            '${task.completedPomodoros}/${task.estimatedPomodoros}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                      if (task.isCompleted)
                        const Icon(Icons.check_circle, size: 20, color: AppColors.success),
                    ],
                  ),
                ],
              ),
              if (!task.isCompleted && task.estimatedPomodoros > 0) ...[
                const SizedBox(height: 12),
                Row(
                  children: List.generate(
                    task.estimatedPomodoros,
                    (i) => Expanded(
                      child: Container(
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i < task.completedPomodoros ? theme.colorScheme.primary : AppColors.surfaceHighlight,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 80)).moveY(begin: 15, end: 0);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          const Text('No tasks in this category', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 8),
          TextButton(onPressed: () => setState(() => _selectedCategory = null), child: const Text('Show all tasks')),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    TaskCategory selectedCat = TaskCategory.work;
    TaskPriority selectedPriority = TaskPriority.medium;
    int estimatedPomodoros = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, setModalState) {
        return Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.surfaceHighlight, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              const Text('New Focus Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'What needs to get done?'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskCategory>(
                      value: selectedCat,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: TaskCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                      onChanged: (v) => setModalState(() => selectedCat = v ?? selectedCat),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<TaskPriority>(
                      value: selectedPriority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: TaskPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                      onChanged: (v) => setModalState(() => selectedPriority = v ?? selectedPriority),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pomodoros estimated', style: TextStyle(color: AppColors.textSecondary)),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => setModalState(() { if (estimatedPomodoros > 1) estimatedPomodoros--; })),
                      Text('$estimatedPomodoros', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setModalState(() { if (estimatedPomodoros < 12) estimatedPomodoros++; })),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isNotEmpty) {
                      final newTask = TaskModel(
                        title: titleController.text.trim(),
                        estimatedPomodoros: estimatedPomodoros,
                        category: selectedCat,
                        priority: selectedPriority,
                      );
                      await ref.read(taskServiceProvider).addTask(newTask);
                      if (context.mounted) Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
