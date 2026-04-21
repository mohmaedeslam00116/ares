# ARES - Roadmap & Changelog

## 📋 Current Version: 1.3.0
**Status:** Dark Mode, Notifications, Tags, Recurring Tasks ✅

---

## 🏆 Priority Roadmap (Best → Worst)

### 🔥 Tier 1 - High Impact (Do First) ✅ COMPLETED

| # | Feature | Status | Priority |
|---|---------|--------|----------|
| 1 | **Dark/Light Theme Toggle** | ✅ Done | ⭐⭐⭐⭐⭐ |
| 2 | **Local Notifications/Reminders** | ✅ Done | ⭐⭐⭐⭐⭐ |
| 3 | **Tags System** | ✅ Done | ⭐⭐⭐⭐ |
| 4 | **Recurring Tasks** | ✅ Done | ⭐⭐⭐⭐ |

### 🎯 Tier 2 - Medium Impact

| # | Feature | Impact | Effort | Why Later |
|---|---------|--------|--------|-----------|
| 5 | **Data Export/Import (JSON)** | ⭐⭐⭐⭐ | ⭐⭐ | Backup important |
| 6 | **Multiple Projects/Lists** | ⭐⭐⭐⭐ | ⭐⭐⭐ | Organize workspaces |
| 7 | **Subtasks** | ⭐⭐⭐ | ⭐⭐⭐ | Complex task breakdown |
| 8 | **Better Animations** | ⭐⭐⭐ | ⭐⭐ | Polish & delight |

### 💡 Tier 3 - Nice to Have

| # | Feature | Impact | Effort | Low Priority |
|---|---------|--------|--------|---------------|
| 9 | **Cloud Backup (Firebase)** | ⭐⭐⭐ | ⭐⭐⭐⭐ | Extra complexity |
| 10 | **AI Task Suggestions** | ⭐⭐⭐ | ⭐⭐⭐⭐ | "AI-powered" branding |
| 11 | **Widget (Android Home)** | ⭐⭐ | ⭐⭐⭐ | Advanced feature |
| 12 | **Collaborative Tasks** | ⭐⭐ | ⭐⭐⭐⭐ | Overkill for v1 |

---

## 📝 CHANGELOG

### [1.3.0] - 2026-04-21 ✅ MAJOR UPDATE

#### Added
- **🌙 Dark/Light Theme Toggle**
  - Full light theme support
  - Theme persists across app restarts
  - Smooth transitions between themes
  
- **🔔 Local Notifications & Reminders**
  - Push notifications before due dates
  - Customizable reminder times (5, 10, 15, 30, 60, 120 min)
  - Permission handling for Android 13+
  
- **🏷️ Tags System**
  - Add custom tags to any task
  - Multi-select tags support
  - Search tasks by tag
  
- **🔄 Recurring Tasks**
  - Daily, Weekly, Monthly, Yearly recurrence
  - Auto-create next occurrence when completed
  - Full recurrence editing

#### Changed
- Task model enhanced with tags, recurrence, and reminder fields
- TaskProvider updated with notification scheduling
- ThemeProvider for persistent theme settings
- Settings screen redesigned with clearer sections

#### Technical
- Added `flutter_local_notifications` package
- Added `timezone` package
- Added `permission_handler` package
- Updated `task.g.dart` for new fields
- CI/CD now builds both Debug and Release APKs

---

### [1.2.0] - 2026-04-20 ✅

#### Added
- **Statistics Dashboard** - View task completion rates, category distribution
- **8 Categories** - Work, Personal, Shopping, Health, Finance, Study, Travel, Other
- **Bottom Navigation** - Home, Statistics, Settings tabs
- **Settings Screen** - Language, theme preferences placeholder
- **Search & Filter** - Real-time task search and priority/category filters
- **Arabic Localization** (l10n) - Full RTL support

#### Changed
- Task model improved with category field
- Provider enhanced with category filtering
- Add/Edit screens with category selection chips

---

### [1.1.0] - 2026-04-20

#### Added
- **Categories Support** - 8 predefined categories
- **Category Filter** - Filter tasks by category
- **Priority Selection** - Low, Medium, High, Urgent

---

### [1.0.0] - Initial Release

#### Added
- Basic Task Management (CRUD)
- Priority System
- Due Dates
- Search functionality
- Hive local storage
- CI/CD with GitHub Actions

---

## 🔧 Technical Notes

### Current Stack
- Flutter 3.24.0 / Dart
- Provider (State Management)
- Hive (Local Storage)
- Google Fonts
- flutter_local_notifications (Reminders)
- GitHub Actions (CI/CD)

### Dependencies (pubspec.yaml)
```yaml
dependencies:
  provider: ^6.1.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  uuid: ^4.5.1
  intl: ^0.19.0
  google_fonts: ^6.2.1
  flutter_local_notifications: ^18.0.1
  timezone: ^0.10.0
  permission_handler: ^11.3.1
```

---

## 📊 Metrics

| Metric | Current | Target |
|--------|---------|--------|
| Features | 19 | 25+ |
| Code Quality | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| CI/CD | ✅ | ✅ (Debug + Release) |
| Dark Mode | ✅ | ✅ |
| Notifications | ✅ | ✅ |
| AI Integration | ❌ | ✅ |

---

## 🚀 Next Steps

1. **Data Export/Import** - JSON backup system
2. **Subtasks** - Break down complex tasks
3. **Cloud Backup** - Firebase integration
4. **AI Features** - Task suggestions

---

*Generated: 2026-04-21*
*Last Updated by: Hermes Agent*
