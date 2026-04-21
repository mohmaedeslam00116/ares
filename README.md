# Hermes - AI-Powered Productivity App

<div align="center">

![Hermes](https://img.shields.io/badge/Hermes-v3.0.0-42A5F5?style=for-the-badge&logo=rocket)
![Flutter](https://img.shields.io/badge/Flutter-3.22.0-02569B?style=for-the-badge&logo=flutter)
![Platform](https://img.shields.io/badge/Platform-Android-34A853?style=for-the-badge&logo=android)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?style=for-the-badge&logo=github-actions)

**Hermes** is a modern, beautifully crafted task management app built with Flutter.
Designed with UI/UX Pro Max principles — clean, fast, and delightful to use.

</div>

---

## ✨ Features

### 🎯 Task Management
- **Create tasks** with title, description, priority, due date, category & tags
- **Swipe to complete** or delete tasks
- **Real-time search** across all tasks
- **Filter** by category, priority, or completion status
- **Task statistics** dashboard (completed, pending, completion rate)

### 🗂️ Organization
- **Categories**: Work, Personal, Shopping, Health, Study, Finance + custom
- **Priority levels**: Low, Medium, High with color coding
- **Tags**: Add multiple tags to tasks for flexible organization
- **Due dates**: Visual badges for overdue, today, tomorrow, and future dates

### 🎨 UI/UX Pro Max
- **Linear/Notion-inspired** modern dark & light themes
- **Material Design 3** with custom color system
- **Smooth animations** and transitions throughout
- **Bottom navigation** for seamless switching between views

### 📱 Screens
- **Home**: Task list with search, filters, and stats dashboard
- **Categories**: Visual grid of all categories with progress indicators
- **Settings**: Theme toggle, language selection, data management

---

## 🏗️ Architecture

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── task.dart            # Task & Category models
│   └── task.g.dart          # Hive TypeAdapters
├── providers/
│   ├── task_provider.dart    # Task state management
│   └── settings_provider.dart # Settings state
├── screens/
│   ├── main_screen.dart      # Bottom navigation host
│   ├── home_screen.dart      # Home with search & filters
│   ├── categories_screen.dart # Category overview
│   ├── add_task_screen.dart  # Create new task
│   └── settings_screen.dart  # App settings
├── widgets/
│   └── task_card.dart        # Modern task card widget
└── theme/
    └── app_theme.dart        # Dark & light themes
```

### Tech Stack
| Technology | Purpose |
|------------|---------|
| **Flutter 3.22** | UI framework |
| **Provider** | State management |
| **Hive** | Local data persistence |
| **Google Fonts** | Inter typography |
| **Material 3** | Design system |

---

## 🚀 CI/CD

Automated builds on every push to `main`:
- ✅ Static analysis (`flutter analyze`)
- ✅ Debug APK build
- ✅ Artifact upload for download
- ✅ Auto-release on git tags

---

## 📄 Changelog

See [CHANGELOG.md](CHANGELOG.md) for full version history.

---

## 📦 Build

```bash
# Get dependencies
flutter pub get

# Run locally
flutter run

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release
```

---

## 🔗 GitHub Actions

APK artifacts are automatically built and uploaded on every push to `main`.
Download latest build from the Actions tab.

---

<p align="center">
  Built with ❤️ using Flutter · Designed with UI/UX Pro Max principles
</p>
