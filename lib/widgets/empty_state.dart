import 'package:flutter/material.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final TaskFilter filter;
  final String searchQuery;

  const EmptyState({
    super.key,
    this.filter = TaskFilter.all,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(),
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              _getTitle(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Subtitle - Fixed: Using separate Text widgets for multiline
            ..._buildSubtitle(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSubtitle() {
    if (searchQuery.isNotEmpty) {
      return [
        const Text(
          'Try a different search term',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ];
    }

    switch (filter) {
      case TaskFilter.pending:
        return [
          const Text(
            'You have no pending tasks.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Enjoy your free time! 🎉',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ];
      case TaskFilter.completed:
        return [
          const Text(
            'Complete some tasks to see them here',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ];
      case TaskFilter.all:
      default:
        return [
          const Text(
            'Tap the + button to create your first task',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ];
    }
  }

  IconData _getIcon() {
    if (searchQuery.isNotEmpty) return Icons.search_off;
    switch (filter) {
      case TaskFilter.pending:
        return Icons.task_alt;
      case TaskFilter.completed:
        return Icons.celebration;
      case TaskFilter.all:
      default:
        return Icons.inbox_outlined;
    }
  }

  String _getTitle() {
    if (searchQuery.isNotEmpty) return 'No results found';
    switch (filter) {
      case TaskFilter.pending:
        return 'All caught up! 🎉';
      case TaskFilter.completed:
        return 'No completed tasks';
      case TaskFilter.all:
      default:
        return 'No tasks yet';
    }
  }
}
