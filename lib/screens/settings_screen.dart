import 'package:flutter/material.dart';
// Unused import removed: 'package:hive/hive.dart'
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../services/locale_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocaleService _localeService = LocaleService();
  bool _isDarkMode = true;
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _localeService.init();
    setState(() {
      _isDarkMode = _localeService.isDarkMode;
      _currentLanguage = _localeService.getCurrentLocale().languageCode;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    setState(() => _isDarkMode = value);
    await _localeService.setDarkMode(value);
  }

  Future<void> _changeLanguage(String languageCode) async {
    setState(() => _currentLanguage = languageCode);
    await _localeService.setLocale(languageCode);
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Appearance Section
          _buildSectionHeader('Appearance'),
          _buildSettingCard([
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Use dark theme',
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
          ]),
          const SizedBox(height: AppSpacing.lg),

          // Language Section
          _buildSectionHeader('Language'),
          _buildSettingCard([
            _buildLanguageTile(
              icon: Icons.language,
              title: 'English',
              isSelected: _currentLanguage == 'en',
              onTap: () => _changeLanguage('en'),
            ),
            const Divider(height: 1, color: AppColors.divider),
            _buildLanguageTile(
              icon: Icons.language,
              title: 'العربية',
              isSelected: _currentLanguage == 'ar',
              onTap: () => _changeLanguage('ar'),
            ),
          ]),
          const SizedBox(height: AppSpacing.lg),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          _buildSettingCard([
            _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Task Reminders',
              subtitle: 'Get notified before due date',
              value: true,
              onChanged: (value) {
                // TODO: Implement notifications
              },
            ),
          ]),
          const SizedBox(height: AppSpacing.lg),

          // About Section
          _buildSectionHeader('About'),
          _buildSettingCard([
            _buildInfoTile(
              icon: Icons.info_outline,
              title: 'Version',
              trailing: '1.0.0',
            ),
            const Divider(height: 1, color: AppColors.divider),
            _buildInfoTile(
              icon: Icons.code,
              title: 'Built with',
              trailing: 'Flutter',
            ),
          ]),
          const SizedBox(height: AppSpacing.lg),

          // Danger Zone
          _buildSectionHeader('Danger Zone'),
          _buildSettingCard([
            _buildActionTile(
              icon: Icons.delete_forever,
              title: 'Clear All Data',
              subtitle: 'Delete all tasks permanently',
              iconColor: AppColors.error,
              onTap: _showClearDataDialog,
            ),
          ]),
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
                const Text(
                  'ARES',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'AI-Powered Productivity',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textTertiary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
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
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
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

  Widget _buildLanguageTile({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.success)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        trailing,
        style: const TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
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
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }
}
