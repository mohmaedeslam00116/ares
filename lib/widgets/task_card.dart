import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../screens/edit_task_screen.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Animation<double>? animation;

  const TaskCard({
    super.key,
    required this.task,
    this.animation,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Calculate due date status
  Color _getDueDateColor() {
    if (widget.task.dueDate == null) return AppColors.textTertiary;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(widget.task.dueDate!.year, widget.task.dueDate!.month, widget.task.dueDate!.day);
    final diff = dueDay.difference(today).inDays;

    if (diff < 0) return AppColors.error; // Overdue
    if (diff == 0) return AppColors.warning; // Today
    if (diff <= 3) return AppColors.priorityMedium; // Soon
    return AppColors.textTertiary;
  }

  String _getDueDateText() {
    if (widget.task.dueDate == null) return '';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(widget.task.dueDate!.year, widget.task.dueDate!.month, widget.task.dueDate!.day);
    final diff = dueDay.difference(today).inDays;

    if (diff < 0) return '${-diff}d overdue';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff <= 7) return 'In $diff days';
    return DateFormat('MMM d').format(widget.task.dueDate!);
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${widget.task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TaskProvider>().deleteTask(widget.task.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: widget.task),
      ),
    );
  }

  Future<void> _toggleComplete(TaskProvider provider) async {
    await _animationController.forward();
    await provider.toggleTask(widget.task.id);
    await _animationController.reverse();
  }

  Widget _buildCard(TaskProvider provider) {
    final isCompleted = widget.task.isCompleted;
    final priorityColor = AppColors.getPriorityColor(widget.task.priority);
    final dueDateColor = _getDueDateColor();
    final dueDateText = _getDueDateText();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm / 2),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.cardBackgroundCompleted : AppColors.cardBackground,
        borderRadius: AppRadius.cardRadius,
        border: Border(
          left: BorderSide(color: priorityColor, width: 4),
        ),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _navigateToEdit,
          borderRadius: AppRadius.cardRadius,
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () => _toggleComplete(provider),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.success : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: isCompleted ? AppColors.success : AppColors.checkboxBorder,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                          decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                          decorationColor: AppColors.textSecondary,
                        ),
                        child: Text(
                          widget.task.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Description
                      if (widget.task.description.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: isCompleted
                                ? AppColors.textSecondary.withOpacity(0.5)
                                : AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // Due date
                      if (dueDateText.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 14, color: dueDateColor),
                            const SizedBox(width: 4),
                            Text(
                              dueDateText,
                              style: TextStyle(
                                fontSize: 12,
                                color: dueDateColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            // Priority badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: priorityColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                AppColors.getPriorityLabel(widget.task.priority),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: priorityColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Menu
                IconButton(
                  onPressed: () => _showDeleteConfirmation(context),
                  icon: const Icon(Icons.more_vert, size: 20),
                  color: AppColors.textTertiary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final card = _buildCard(provider);

        // Apply animation if provided (for list animations)
        if (widget.animation != null) {
          return SizeTransition(
            sizeFactor: widget.animation!,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(widget.animation!),
              child: FadeTransition(
                opacity: widget.animation!,
                child: card,
              ),
            ),
          );
        }

        // Apply scale animation
        return ScaleTransition(
          scale: _scaleAnimation,
          child: card,
        );
      },
    );
  }
}

// Swipeable wrapper for task card
class SwipeableTaskCard extends StatelessWidget {
  final Task task;
  final Animation<double>? animation;

  const SwipeableTaskCard({
    super.key,
    required this.task,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        // Show confirmation dialog instead of direct delete
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: Text('Are you sure you want to delete "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<TaskProvider>().deleteTask(task.id);
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        return false;
      },
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm / 2),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.2),
          borderRadius: AppRadius.cardRadius,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: AppColors.error, size: 28),
      ),
      child: TaskCard(task: task, animation: animation),
    );
  }
}
