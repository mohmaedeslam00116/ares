import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagController;

  DateTime? _selectedDueDate;
  String _selectedPriority = 'medium';
  String? _selectedCategory;
  List<String> _selectedTags = [];
  int _selectedRecurrence = 0;
  bool _reminderEnabled = true;
  int _reminderMinutes = 30;
  bool _isLoading = false;

  final List<String> _priorities = ['low', 'medium', 'high'];
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
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _tagController = TextEditingController();
    _selectedDueDate = widget.task.dueDate;
    _selectedPriority = widget.task.priority;
    _selectedCategory = widget.task.category;
    _selectedTags = List.from(widget.task.tags);
    _selectedRecurrence = widget.task.recurrenceType;
    _reminderEnabled = widget.task.reminderEnabled;
    _reminderMinutes = widget.task.reminderMinutesBefore;
  }

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
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
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

  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title cannot be empty'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await context.read<TaskProvider>().updateTask(
          id: widget.task.id,
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

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task updated successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update task'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.scaffoldBackground : const Color(0xFFFAFAFA);
    final cardBg = isDark ? AppColors.cardBackground : Colors.white;
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF666666);
    final surfaceElevated = isDark ? AppColors.surfaceElevated : const Color(0xFFF0F0F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        title: const Text(
          'Edit Task',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveTask,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            _buildLabel('Title', textSecondary),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: TextStyle(color: textPrimary),
              decoration: InputDecoration(
                hintText: 'Enter task title',
                filled: true,
                fillColor: surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description field
            _buildLabel('Description', textSecondary),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: textPrimary),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter task description',
                filled: true,
                fillColor: surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category field
            _buildLabel('Category', textSecondary),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return InkWell(
                  onTap: () => setState(() {
                    _selectedCategory = isSelected ? null : category;
                  }),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.2)
                          : surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _getCategoryLabel(category),
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Recurrence field
            _buildLabel('Repeat', textSecondary),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recurrenceOptions.map((option) {
                final isSelected = _selectedRecurrence == option['value'];
                return InkWell(
                  onTap: () => setState(() {
                    _selectedRecurrence = option['value'];
                  }),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.2)
                          : surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          option['icon'],
                          size: 16,
                          color: isSelected ? AppColors.primary : textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          option['label'],
                          style: TextStyle(
                            color: isSelected ? AppColors.primary : textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Priority field
            _buildLabel('Priority', textSecondary),
            const SizedBox(height: 8),
            Row(
              children: _priorities.map((priority) {
                final isSelected = _selectedPriority == priority;
                final color = priority == 'high'
                    ? AppColors.priorityHigh
                    : priority == 'low'
                        ? AppColors.priorityLow
                        : AppColors.priorityMedium;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: priority != _priorities.last ? 8 : 0,
                    ),
                    child: InkWell(
                      onTap: () => setState(() => _selectedPriority = priority),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withOpacity(0.2)
                              : surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? color : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            priority[0].toUpperCase() + priority.substring(1),
                            style: TextStyle(
                              color: isSelected ? color : textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Tags field
            _buildLabel('Tags', textSecondary),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    style: TextStyle(color: textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Add tag...',
                      prefixIcon: const Icon(Icons.add, size: 20),
                      filled: true,
                      fillColor: surfaceElevated,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addTag,
                  icon: const Icon(Icons.add_circle),
                  color: AppColors.primary,
                ),
              ],
            ),
            if (_selectedTags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedTags.map((tag) {
                  return Chip(
                    label: Text(
                      tag,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: AppColors.info.withOpacity(0.2),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeTag(tag),
                    side: const BorderSide(color: AppColors.info),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 20),

            // Due date field
            _buildLabel('Due Date', textSecondary),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDueDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDueDate != null
                          ? DateFormat('MMM d, yyyy').format(_selectedDueDate!)
                          : 'Select due date',
                      style: TextStyle(
                        color: _selectedDueDate != null
                            ? textPrimary
                            : AppColors.textHint,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedDueDate != null)
                      IconButton(
                        onPressed: _clearDueDate,
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ),
            ),

            // Reminder section
            if (_selectedDueDate != null) ...[
              const SizedBox(height: 20),
              _buildLabel('Reminder', textSecondary),
              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(
                  'Enable Reminder',
                  style: TextStyle(color: textPrimary),
                ),
                subtitle: Text(
                  'Notify $_reminderMinutes minutes before',
                  style: TextStyle(color: textSecondary),
                ),
                value: _reminderEnabled,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() {
                    _reminderEnabled = value;
                  });
                },
              ),
              if (_reminderEnabled)
                Wrap(
                  spacing: 8,
                  children: _reminderOptions.map((minutes) {
                    final isSelected = _reminderMinutes == minutes;
                    return ChoiceChip(
                      label: Text(
                        _formatReminderMinutes(minutes),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : textSecondary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: surfaceElevated,
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
            ],
            const SizedBox(height: 32),

            // Delete button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showDeleteConfirmation(),
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                label: const Text(
                  'Delete Task',
                  style: TextStyle(color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Delete Task',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.task.title}"?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TaskProvider>().deleteTask(widget.task.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
