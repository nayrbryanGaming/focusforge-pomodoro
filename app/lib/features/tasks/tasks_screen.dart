import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Focus Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
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
              _buildProgressHeader(theme, tasks.length, completedCount),
              _buildCategoryChips(theme),
              Expanded(
                child: filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        error: (err, stack) => Center(child: Text('Error loading tasks: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        label: const Text('New Task', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
        elevation: 4,
        highlightElevation: 8,
      ),
    );
  }

  Widget _buildProgressHeader(ThemeData theme, int total, int completed) {
    double progress = total == 0 ? 0 : completed / total;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.2),
            theme.colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Forge Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$completed of $total tasks completed',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    color: theme.colorScheme.primary,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.white.withValues(alpha: 0.03),
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -1),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildCategoryChips(ThemeData theme) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _categoryChip(null, 'All', Icons.grid_view_rounded, theme),
          _categoryChip(TaskCategory.work, 'Work', Icons.work_rounded, theme),
          _categoryChip(TaskCategory.study, 'Study', Icons.school_rounded, theme),
          _categoryChip(TaskCategory.personal, 'Personal', Icons.self_improvement_rounded, theme),
          _categoryChip(TaskCategory.other, 'Other', Icons.more_horiz_rounded, theme),
        ],
      ),
    );
  }

  Widget _categoryChip(TaskCategory? category, String label, IconData icon, ThemeData theme) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedCategory = category);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.white.withValues(alpha: 0.08),
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))
          ] : [],
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task, int index) {
    final theme = Theme.of(context);
    final priorityColor = task.priority == TaskPriority.high
        ? Colors.redAccent
        : task.priority == TaskPriority.medium ? AppColors.accent : Colors.grey;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.redAccent),
      ),
      confirmDismiss: (dir) async {
        final result = await _showDeleteConfirm(task.title);
        if (result == true) {
          await ref.read(taskServiceProvider).deleteTask(task.id);
          return true;
        }
        return false;
      },
      child: GestureDetector(
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: task.isCompleted 
                  ? AppColors.success.withValues(alpha: 0.3) 
                  : Colors.white.withValues(alpha: 0.05),
              width: 1.0,
            ),
            boxShadow: [
              if (!task.isCompleted)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 36,
                          decoration: BoxDecoration(
                            color: priorityColor,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(color: priorityColor.withValues(alpha: 0.5), blurRadius: 10)
                            ],
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                  color: task.isCompleted ? AppColors.textSecondary : Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildSmallTag(task.category.name.toUpperCase(), Colors.white.withValues(alpha: 0.05)),
                                  const SizedBox(width: 12),
                                  Icon(Icons.timer_outlined, size: 14, color: AppColors.textSecondary),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${task.completedPomodoros} / ${task.estimatedPomodoros} Forge Sessions',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _buildTaskAction(task),
                      ],
                    ),
                    if (!task.isCompleted && task.estimatedPomodoros > 0) ...[
                      const SizedBox(height: 20),
                      _buildPomodoroProgressMarks(task, theme),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 40).ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
  }

  Widget _buildSmallTag(String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w900, letterSpacing: 0.8),
      ),
    );
  }

  Widget _buildTaskAction(TaskModel task) {
    if (task.isCompleted) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
        child: const Icon(Icons.check, color: Colors.white, size: 18),
      ).animate().scale();
    }
    return IconButton(
      icon: const Icon(Icons.circle_outlined, color: Colors.white24, size: 28),
      onPressed: () {
        HapticFeedback.lightImpact();
        ref.read(taskServiceProvider).updateTask(task.copyWith(isCompleted: true));
      },
    );
  }

  Widget _buildPomodoroProgressMarks(TaskModel task, ThemeData theme) {
    return Row(
      children: List.generate(
        task.estimatedPomodoros,
        (i) => Expanded(
          child: Container(
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
              color: i < task.completedPomodoros 
                  ? theme.colorScheme.primary 
                  : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              boxShadow: i < task.completedPomodoros ? [
                BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.4), blurRadius: 6)
              ] : [],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_outlined, size: 64, color: Colors.white10),
          ),
          const SizedBox(height: 24),
          const Text('All clear in the Forge', style: TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Create a task to start your focus journey.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          if (_selectedCategory != null)
            TextButton(onPressed: () => setState(() => _selectedCategory = null), child: const Text('Show all categories')),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirm(String title) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Task?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to remove "$title"?', style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep it')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Delete'),
          ),
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
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setModalState) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1F36),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              const Text('Forge New Task', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'What are we focusing on?',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Category & Priority', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown<TaskCategory>(
                      value: selectedCat,
                      items: TaskCategory.values,
                      onChanged: (v) => setModalState(() => selectedCat = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdown<TaskPriority>(
                      value: selectedPriority,
                      items: TaskPriority.values,
                      onChanged: (v) => setModalState(() => selectedPriority = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pomodoros Estimated', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        IconButton(icon: const Icon(Icons.remove, color: Colors.white54), onPressed: () => setModalState(() { if (estimatedPomodoros > 1) estimatedPomodoros--; })),
                        Text('$estimatedPomodoros', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primary)),
                        IconButton(icon: const Icon(Icons.add, color: Colors.white54), onPressed: () => setModalState(() { if (estimatedPomodoros < 12) estimatedPomodoros++; })),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
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
                      if (ctx.mounted) Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('START FORGING', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDropdown<T extends Enum>(
      {required T value, required List<T> items, required ValueChanged<T?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF1E2640),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.name.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
