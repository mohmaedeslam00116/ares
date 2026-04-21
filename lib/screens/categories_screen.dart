import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<Map<String, dynamic>> _defaultCategories = [
    {'name': 'General', 'icon': Icons.task_alt_rounded, 'color': Color(0xFF42A5F5)},
    {'name': 'Work', 'icon': Icons.work_rounded, 'color': Color(0xFFEF5350)},
    {'name': 'Personal', 'icon': Icons.person_rounded, 'color': Color(0xFFAB47BC)},
    {'name': 'Shopping', 'icon': Icons.shopping_cart_rounded, 'color': Color(0xFFFFA726)},
    {'name': 'Health', 'icon': Icons.favorite_rounded, 'color': Color(0xFF66BB6A)},
    {'name': 'Study', 'icon': Icons.school_rounded, 'color': Color(0xFF26C6DA)},
    {'name': 'Finance', 'icon': Icons.account_balance_wallet_rounded, 'color': Color(0xFFFFCA28)},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = _defaultCategories;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final cat = categories[index];
                    final taskCount = provider.allTasks
                        .where((t) => t.category == cat['name'])
                        .length;
                    final completedCount = provider.allTasks
                        .where((t) => t.category == cat['name'] && t.isCompleted)
                        .length;

                    return _CategoryCard(
                      name: cat['name'],
                      icon: cat['icon'],
                      color: cat['color'],
                      taskCount: taskCount,
                      completedCount: completedCount,
                      isDark: isDark,
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final int taskCount;
  final int completedCount;
  final bool isDark;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.taskCount,
    required this.completedCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progress = taskCount == 0 ? 0.0 : completedCount / taskCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A2E) : const Color(0xFFE8E8EC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                '$taskCount',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? const Color(0xFF2A2A2E) : const Color(0xFFE8E8EC),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$completedCount of $taskCount done',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? const Color(0xFF6B6B6F) : const Color(0xFF9A9A9E),
            ),
          ),
        ],
      ),
    );
  }
}
