import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();

  DateTime? _selectedDueDate;
  String _selectedPriority = 'medium';
  String? _selectedCategory;
  List<String> _selectedTags = [];
  int _selectedRecurrence = 0;
  bool _reminderEnabled = true;
  int _reminderMinutes = 30;
  bool _isLoading = false;

  static const List<String> _categories = [
    'work',
    'personal',
    'health',
    'shopping',
    'study',
    'finance',
    'home',
    'other',
  ];

  static const List<Map<String, dynamic>> _recurrenceOptions = [
    {'value': 0, 'label': 'No Repeat', 'icon': Icons.repeat},
    {'value': 1, 'label': 'Daily', 'icon': Icons.today},
    {'value': 2, 'label': 'Weekly', 'icon': Icons.date_range},
    {'value': 3, 'label': 'Monthly', 'icon': Icons.calendar_month},
    {'value': 4, 'label': 'Yearly', 'icon': Icons.event_repeat},
  ];

  static const List<int> _reminderOptions = [5, 10, 15, 30, 60, 120];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _clearDueDate() {
    setState(() {
      _selectedDueDate = null;
    });
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  String _getCategoryLabel(String category) {
    final labels = {
      'work': '💼 Work',
      'personal': '👤 Personal',
      'health': '❤️ Health',
      'shopping': '🛒 Shopping',
      'study': '📚 Study',
      'finance': '💰 Finance',
      'home': '🏠 Home',
      'other': '📌 Other',
    };
    return labels[category] ?? category;
  }

  String _formatReminderMinutes(int minutes) {
    if (minutes < 60) return '$minutes min';
    return '${minutes ~/ 60} hr${minutes >= 120 ? 's' : ''}';
  }

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      final success = await provider.addTask(
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
        category: _selectedCategory,
        tags: _selectedTags,
        recurrenceType: _selectedRecurrence,
        reminderEnabled: _reminderEnabled && _selectedDueDate != null,
        reminderMinutesBefore: _reminderMinutes,
      );

      if (success && mounted) {
        Navigator.pop(context);
      } else if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'Failed to add task'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldBackground : LightColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter task title',
                  prefixIcon: const Icon(Icons.title),
                  filled: true,
                  fillColor: isDark ? DarkColors.surfaceElevated : LightColors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.inputRadius,
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                  fontSize: 16,
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task description (optional)',
                  prefixIcon: const Icon(Icons.description),
                  filled: true,
                  fillColor: isDark ? DarkColors.surfaceElevated : LightColors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.inputRadius,
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                  fontSize: 16,
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category Section
              _SectionHeader(
                icon: Icons.category,
                title: 'Category',
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    label: Text(
                      _getCategoryLabel(category),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? DarkColors.textSecondary : LightColors.textSecondary),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: isDark ? DarkColors.surfaceElevated : LightColors.surfaceElevated,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Due Date Section
              _SectionHeader(
                icon: Icons.calendar_today,
                title: 'Due Date',
              ),
              const SizedBox(height: AppSpacing.sm),
              _selectedDueDate != null
                  ? Row(
                      children: [
                        Expanded(
                          child: Chip(
                            label: Text(
                              DateFormat('MMM d, yyyy').format(_selectedDueDate!),
                              style: TextStyle(
                                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                              ),
                            ),
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            deleteIcon: Icon(
                              Icons.close,
                              size: 18,
                            ),
                            onDeleted: _clearDueDate,
                            side: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ],
                    )
                  : OutlinedButton.icon(
                      onPressed: _selectDueDate,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Select Due Date'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.buttonRadius,
                        ),
                      ),
                    ),
              const SizedBox(height: AppSpacing.lg),

              // Recurrence Section
              _SectionHeader(
                icon: Icons.repeat,
                title: 'Repeat',
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _recurrenceOptions.map((option) {
                  final isSelected = _selectedRecurrence == option['value'];
                  return ChoiceChip(
                    avatar: Icon(
                      option['icon'],
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? DarkColors.textSecondary : LightColors.textSecondary),
                    ),
                    label: Text(
                      option['label'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? DarkColors.textSecondary : LightColors.textSecondary),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: isDark ? DarkColors.surfaceElevated : LightColors.surfaceElevated,
                    onSelected: (selected) {
                      setState(() {
                        _selectedRecurrence = option['value'];
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Priority Section
              _SectionHeader(
                icon: Icons.flag,
                title: 'Priority',
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: ['low', 'medium', 'high'].map((priority) {
                  final isSelected = _selectedPriority == priority;
                  final color = AppColors.getPriorityColor(priority);
                  return ChoiceChip(
                    label: Text(
                      AppColors.getPriorityLabel(priority),
                      style: TextStyle(
                        color: isSelected ? Colors.white : color,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: color,
                    backgroundColor: isDark ? DarkColors.surfaceElevated : LightColors.surfaceElevated,
                    side: BorderSide(color: color, width: isSelected ? 2 : 1),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPriority = priority;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Tags Section
              _SectionHeader(
                icon: Icons.label,
                title: 'Tags',
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        hintText: 'Add tag...',
                        prefixIcon: const Icon(Icons.add),
                        filled: true,
                        fillColor: isDark ? DarkColors.surfaceElevated : LightColors.surfaceElevated,
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.inputRadius,
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                      ),
                      onSubmitted: (_) => _addTag(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    onPressed: _addTag,
                    icon: const Icon(Icons.add_circle),
                    color: AppColors.primary,
                  ),
                ],
              ),
              if (_selectedTags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _selectedTags.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                        ),
                      ),
                      backgroundColor: AppColors.info.withOpacity(0.2),
                      deleteIcon: Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onDeleted: () => _removeTag(tag),
                      side: const BorderSide(color: AppColors.info),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),

              // Reminder Section
              if (_selectedDueDate != null) ...[
                _SectionHeader(
                  icon: Icons.notifications,
                  title: 'Reminder',
                ),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile(
                  title: Text(
                    'Enable Reminder',
                    style: TextStyle(
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Notify $_reminderMinutes minutes before',
                    style: TextStyle(
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),
                  value: _reminderEnabled,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _reminderEnabled = value;
                    });
                  },
                ),
                if (_reminderEnabled)
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: _reminderOptions.map((minutes) {
                      final isSelected = _reminderMinutes == minutes;
                      return ChoiceChip(
                        label: Text(
                          _formatReminderMinutes(minutes),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? DarkColors.textSecondary : LightColors.textSecondary),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: isDark ? DarkColors.surfaceElevated : LightColors.surfaceElevated,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _reminderMinutes = minutes;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.buttonRadius,
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Add Task',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget for section headers
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: TextStyle(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Import for LightColors
class LightColors {
  static const Color primary = Color(0xFFE53935);
  static const Color scaffoldBackground = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF0F0F0);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
}

class DarkColors {
  static const Color primary = Color(0xFFE53935);
  static const Color scaffoldBackground = Color(0xFF121212);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF242424);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
}
