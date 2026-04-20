import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'appName': 'ARES',
      'appTagline': 'AI-Powered Productivity',
      
      // Navigation
      'home': 'Home',
      'settings': 'Settings',
      'profile': 'Profile',
      
      // Tasks
      'addTask': 'Add Task',
      'editTask': 'Edit Task',
      'deleteTask': 'Delete Task',
      'taskTitle': 'Title',
      'taskDescription': 'Description',
      'dueDate': 'Due Date',
      'priority': 'Priority',
      'category': 'Category',
      'tags': 'Tags',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      
      // Priorities
      'high': 'High',
      'medium': 'Medium',
      'low': 'Low',
      
      // Filters
      'all': 'All',
      'pending': 'Pending',
      'completed': 'Completed',
      
      // Empty States
      'noTasks': 'No tasks yet',
      'noTasksSubtitle': 'Tap the + button to create your first task',
      'allCaughtUp': 'All caught up! 🎉',
      'noPendingTasks': 'You have no pending tasks.',
      'enjoyFreeTime': 'Enjoy your free time!',
      'noCompletedTasks': 'No completed tasks',
      'completeTasksToSee': 'Complete some tasks to see them here',
      'noResults': 'No results found',
      'tryDifferentSearch': 'Try a different search term',
      
      // Stats
      'pendingCount': 'Pending',
      'doneCount': 'Done',
      'overdue': 'Overdue',
      'highPriority': 'High Priority',
      
      // Greetings
      'goodMorning': 'Good morning! ☀️',
      'goodAfternoon': 'Good afternoon! 🌤️',
      'goodEvening': 'Good evening! 🌙',
      
      // Settings
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'arabic': 'Arabic',
      'english': 'English',
      'notifications': 'Notifications',
      'taskReminders': 'Task Reminders',
      'about': 'About',
      'version': 'Version',
      'clearData': 'Clear All Data',
      'clearDataConfirm': 'Are you sure you want to delete all tasks? This cannot be undone.',
      
      // Actions
      'retry': 'Retry',
      'search': 'Search',
      'searchTasks': 'Search tasks...',
      
      // Messages
      'taskAdded': 'Task added successfully',
      'taskUpdated': 'Task updated successfully',
      'taskDeleted': 'Task deleted successfully',
      'errorOccurred': 'Oops! Something went wrong',
      'titleRequired': 'Title is required',
      'titleTooShort': 'Title must be at least 3 characters',
    },
    'ar': {
      // App
      'appName': 'أرِس',
      'appTagline': 'إنتاجية مدعومة بالذكاء الاصطناعي',
      
      // Navigation
      'home': 'الرئيسية',
      'settings': 'الإعدادات',
      'profile': 'الملف الشخصي',
      
      // Tasks
      'addTask': 'إضافة مهمة',
      'editTask': 'تعديل المهمة',
      'deleteTask': 'حذف المهمة',
      'taskTitle': 'العنوان',
      'taskDescription': 'الوصف',
      'dueDate': 'تاريخ الاستحقاق',
      'priority': 'الأولوية',
      'category': 'الفئة',
      'tags': 'الوسوم',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      
      // Priorities
      'high': 'عالية',
      'medium': 'متوسطة',
      'low': 'منخفضة',
      
      // Filters
      'all': 'الكل',
      'pending': 'قيد الانتظار',
      'completed': 'مكتملة',
      
      // Empty States
      'noTasks': 'لا توجد مهام بعد',
      'noTasksSubtitle': 'اضغط على + لإنشاء مهمتك الأولى',
      'allCaughtUp': 'أنت في قمة التألق! 🎉',
      'noPendingTasks': 'لا توجد مهام معلقة.',
      'enjoyFreeTime': 'استمتع بوقتك!',
      'noCompletedTasks': 'لا توجد مهام مكتملة',
      'completeTasksToSee': 'أكمل بعض المهام لرؤيتها هنا',
      'noResults': 'لم يتم العثور على نتائج',
      'tryDifferentSearch': 'جرب مصطلح بحث مختلف',
      
      // Stats
      'pendingCount': 'معلقة',
      'doneCount': 'مكتملة',
      'overdue': 'متأخرة',
      'highPriority': 'أولوية عالية',
      
      // Greetings
      'goodMorning': 'صباح الخير! ☀️',
      'goodAfternoon': 'مساء الخير! 🌤️',
      'goodEvening': 'مساء النور! 🌙',
      
      // Settings
      'appearance': 'المظهر',
      'darkMode': 'الوضع الداكن',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'الإنجليزية',
      'notifications': 'الإشعارات',
      'taskReminders': 'تذكيرات المهام',
      'about': 'حول التطبيق',
      'version': 'الإصدار',
      'clearData': 'مسح جميع البيانات',
      'clearDataConfirm': 'هل أنت متأكد من حذف جميع المهام؟ لا يمكن التراجع عن هذا.',
      
      // Actions
      'retry': 'إعادة المحاولة',
      'search': 'بحث',
      'searchTasks': 'البحث في المهام...',
      
      // Messages
      'taskAdded': 'تمت إضافة المهمة بنجاح',
      'taskUpdated': 'تم تحديث المهمة بنجاح',
      'taskDeleted': 'تم حذف المهمة بنجاح',
      'errorOccurred': 'عذراً! حدث خطأ ما',
      'titleRequired': 'العنوان مطلوب',
      'titleTooShort': 'يجب أن يكون العنوان 3 أحرف على الأقل',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
           _localizedValues['en']?[key] ??
           key;
  }

  // Quick access getters
  String get appName => translate('appName');
  String get home => translate('home');
  String get settings => translate('settings');
  String get addTask => translate('addTask');
  String get editTask => translate('editTask');
  String get deleteTask => translate('deleteTask');
  String get taskTitle => translate('taskTitle');
  String get taskDescription => translate('taskDescription');
  String get dueDate => translate('dueDate');
  String get priority => translate('priority');
  String get category => translate('category');
  String get tags => translate('tags');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get delete => translate('delete');
  String get high => translate('high');
  String get medium => translate('medium');
  String get low => translate('low');
  String get all => translate('all');
  String get pending => translate('pending');
  String get completed => translate('completed');
  String get searchTasks => translate('searchTasks');
  String get retry => translate('retry');
  String get search => translate('search');
  String get pendingCount => translate('pendingCount');
  String get doneCount => translate('doneCount');
  
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return translate('goodMorning');
    if (hour < 17) return translate('goodAfternoon');
    return translate('goodEvening');
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
