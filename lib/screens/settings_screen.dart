import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.scaffoldBackground : const Color(0xFFFAFAFA);
    final surfaceColor = isDark ? AppColors.surface : Colors.white;
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF666666);
    final textTertiary = isDark ? AppColors.textTertiary : const Color(0xFF999999);
    final dividerColor = isDark ? AppColors.divider : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: surfaceColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Appearance Section
          _buildSectionHeader('Appearance', textTertiary),
          _buildSettingCard([
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return _buildSwitchTile(
                  icon: isDark ? Icons.dark_mode : Icons.light_mode,
                  title: 'Dark Mode',
                  subtitle: isDark ? 'Currently using dark theme' : 'Currently using light theme',
                  value: isDark,
                  onChanged: (value) {
                    themeProvider.setDarkMode(value);
                  },
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                );
              },
            ),
          ], surfaceColor),
          const SizedBox(height: AppSpacing.lg),

          // Notifications Section
          _buildSectionHeader('Notifications', textTertiary),
          _buildSettingCard([
            _buildInfoTile(
              icon: Icons.notifications,
              title: 'Task Reminders',
              subtitle: 'Get notified before due date',
              trailing: 'Enabled',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              iconColor: AppColors.success,
            ),
          ], surfaceColor),
          const SizedBox(height: AppSpacing.lg),

          // Data Section
          _buildSectionHeader('Data', textTertiary),
          _buildSettingCard([
            _buildActionTile(
              icon: Icons.delete_forever,
              title: 'Clear All Data',
              subtitle: 'Delete all tasks permanently',
              iconColor: AppColors.error,
              textPrimary: textPrimary,
              onTap: _showClearDataDialog,
            ),
          ], surfaceColor),
          const SizedBox(height: AppSpacing.lg),

          // About Section
          _buildSectionHeader('About', textTertiary),
          _buildSettingCard([
            _buildInfoTile(
              icon: Icons.info_outline,
              title: 'Version',
              trailing: '1.3.0',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              iconColor: AppColors.primary,
            ),
            Divider(height: 1, color: dividerColor),
            _buildInfoTile(
              icon: Icons.code,
              title: 'Built with',
              trailing: 'Flutter',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              iconColor: AppColors.info,
            ),
            Divider(height: 1, color: dividerColor),
            _buildInfoTile(
              icon: Icons.auto_awesome,
              title: 'Features',
              trailing: '12+',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              iconColor: AppColors.warning,
            ),
          ], surfaceColor),
          const SizedBox(height: AppSpacing.xxl),

          // Footer
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.bolt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'ARES',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI-Powered Productivity',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'v1.3.0 - Now with Dark Mode, Notifications & Tags',
                  style: TextStyle(
                    fontSize: 10,
                    color: textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingCard(List<Widget> children, Color surfaceColor) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String trailing,
    required Color textPrimary,
    required Color textSecondary,
    required Color iconColor,
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: textSecondary,
                fontSize: 12,
              ),
            )
          : null,
      trailing: Text(
        trailing,
        style: TextStyle(
          color: textSecondary,
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color textPrimary,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: iconColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: textSecondary,
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Clear All Data',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to delete all tasks? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _clearAllTasks();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllTasks() async {
    final provider = context.read<TaskProvider>();
    final tasks = provider.tasks;

    for (final task in tasks) {
      await provider.deleteTask(task.id);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All tasks deleted'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
