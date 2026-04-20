import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme.dart' show AppSpacing, AppRadius;

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final totalTasks = provider.tasks.length;
          final pendingTasks = provider.pendingCount;
          final completedTasks = provider.completedCount;
          final completionRate = totalTasks > 0 
              ? (completedTasks / totalTasks * 100).round() 
              : 0;

          return SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Cards
                _buildSectionTitle('Overview'),
                const SizedBox(height: AppSpacing.md),
                
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Total',
                        value: totalTasks.toString(),
                        icon: Icons.list_alt,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatCard(
                        title: 'Pending',
                        value: pendingTasks.toString(),
                        icon: Icons.pending_actions,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Completed',
                        value: completedTasks.toString(),
                        icon: Icons.check_circle,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatCard(
                        title: 'Completion',
                        value: '$completionRate%',
                        icon: Icons.pie_chart,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Priority Breakdown
                _buildSectionTitle('By Priority'),
                const SizedBox(height: AppSpacing.md),
                _PriorityBreakdown(provider: provider),
                const SizedBox(height: AppSpacing.xl),

                // Category Breakdown
                _buildSectionTitle('By Category'),
                const SizedBox(height: AppSpacing.md),
                _CategoryBreakdown(provider: provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityBreakdown extends StatelessWidget {
  final TaskProvider provider;

  const _PriorityBreakdown({required this.provider});

  @override
  Widget build(BuildContext context) {
    final tasks = provider.tasks;
    final highTasks = tasks.where((t) => t.priority == 'high').length;
    final mediumTasks = tasks.where((t) => t.priority == 'medium').length;
    final lowTasks = tasks.where((t) => t.priority == 'low').length;
    final total = tasks.length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        children: [
          _PriorityBar(
            label: 'High',
            count: highTasks,
            total: total,
            color: AppColors.priorityHigh,
          ),
          const SizedBox(height: AppSpacing.md),
          _PriorityBar(
            label: 'Medium',
            count: mediumTasks,
            total: total,
            color: AppColors.priorityMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          _PriorityBar(
            label: 'Low',
            count: lowTasks,
            total: total,
            color: AppColors.priorityLow,
          ),
        ],
      ),
    );
  }
}

class _PriorityBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _PriorityBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? count / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  final TaskProvider provider;

  const _CategoryBreakdown({required this.provider});

  @override
  Widget build(BuildContext context) {
    final tasks = provider.tasks;
    
    // Count tasks by category
    final categoryCounts = <String, int>{};
    for (final task in tasks) {
      final cat = task.category ?? 'other';
      categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
    }

    if (categoryCounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: AppRadius.cardRadius,
        ),
        child: const Center(
          child: Text(
            'No categories yet',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final sortedCategories = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final categoryLabels = {
      'work': '💼 Work',
      'personal': '👤 Personal',
      'health': '❤️ Health',
      'shopping': '🛒 Shopping',
      'study': '📚 Study',
      'finance': '💰 Finance',
      'home': '🏠 Home',
      'other': '📌 Other',
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        children: sortedCategories.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoryLabels[entry.key] ?? entry.key,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  entry.value.toString(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}