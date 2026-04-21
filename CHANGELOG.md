# ARES - Roadmap & Changelog

## 📋 Current Version: 1.2.0
**Status:** Statistics Dashboard added, 8 Categories, Search/Filter

---

## 🏆 Priority Roadmap (Best → Worst)

### 🔥 Tier 1 - High Impact (Do First)

| # | Feature | Impact | Effort | Why First |
|---|---------|--------|--------|-----------|
| 1 | **Dark/Light Theme Toggle** | ⭐⭐⭐⭐⭐ | ⭐ | 80% of users expect this |
| 2 | **Local Notifications/Reminders** | ⭐⭐⭐⭐⭐ | ⭐⭐ | Core functionality missing |
| 3 | **Tags System** | ⭐⭐⭐⭐ | ⭐⭐ | Already have categories, tags complement |
| 4 | **Recurring Tasks** | ⭐⭐⭐⭐ | ⭐⭐ | Daily/Weekly/Monthly repeat |

### 🎯 Tier 2 - Medium Impact

| # | Feature | Impact | Effort | Why Later |
|---|---------|--------|--------|-----------|
| 5 | **Data Export/Import (JSON)** | ⭐⭐⭐⭐ | ⭐⭐ | Backup important |
| 6 | **Multiple Projects/Lists** | ⭐⭐⭐⭐ | ⭐⭐⭐ | Organize workspaces |
| 7 | **Subtasks** | ⭐⭐⭐ | ⭐⭐⭐ | Complex task breakdown |
| 8 | **Better Animations** | ⭐⭐⭐ | ⭐⭐ | Polish & delight |

### 💡 Tier 3 - Nice to Have

| # | Feature | Impact | Effort | Low Priority |
|---|---------|--------|--------|-------------|
| 9 | **Cloud Backup (Firebase)** | ⭐⭐⭐ | ⭐⭐⭐⭐ | Extra complexity |
| 10 | **AI Task Suggestions** | ⭐⭐⭐ | ⭐⭐⭐⭐ | "AI-powered" branding |
| 11 | **Widget (Android Home)** | ⭐⭐ | ⭐⭐⭐ | Advanced feature |
| 12 | **Collaborative Tasks** | ⭐⭐ | ⭐⭐⭐⭐ | Overkill for v1 |

---

## 📝 CHANGELOG

### [Unreleased] - v1.3.0 (Planned)

#### Added
- _(Planned) Dark/Light Theme Toggle_
- _(Planned) Local Notifications/Reminders_
- _(Planned) Tags System_
- _(Planned) Recurring Tasks (daily/weekly/monthly)_
- _(Planned) JSON Export/Import_

#### Improved
- _(Planned) UI Animations & Transitions_

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
- Flutter 3.0+ / Dart
- Provider (State Management)
- Hive (Local Storage)
- Google Fonts
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
```

### Recommended Future Dependencies
```yaml
# For Tier 1 features:
flutter_local_notifications: ^17.0.0  # Reminders
share_plus: ^7.0.0                    # Export sharing
file_picker: ^6.0.0                   # Import files

# For Tier 2 features:
flutter_animate: ^4.0.0               # Animations
```

---

## 📊 Metrics

| Metric | Current | Target |
|--------|---------|--------|
| Features | 15 | 25+ |
| Code Quality | Good | Excellent |
| CI/CD | ✅ | ✅ |
| Dark Mode | ❌ | ✅ |
| Notifications | ❌ | ✅ |
| AI Integration | ❌ | ✅ |

---

## 🚀 Recommended Next Steps

1. **Immediate**: Add Dark/Light Theme Toggle
2. **This Week**: Add Notifications/Reminders
3. **This Month**: Tags + Recurring Tasks
4. **Future**: Cloud Backup, AI Features

---

*Generated: 2026-04-21*
*Last Updated by: Hermes Agent*
