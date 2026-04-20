# ARES - AI-Powered Productivity Task Manager

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.41.7-blue.svg" alt="Flutter">
  <img src="https://img.shields.io/badge/Status-Stable-green.svg" alt="Status">
  <img src="https://img.shields.io/github/v/release/mohmaedeslam00116/ares.svg" alt="Release">
  <img src="https://img.shields.io/github/license/mohmaedeslam00116/ares.svg" alt="License">
</p>

---

## 🎯 About ARES

**ARES** (Advanced Recognition & Efficiency System) is an AI-powered productivity task manager built with Flutter for Android. It helps you organize tasks, set priorities, and track progress with a beautiful dark-themed UI.

---

## ✨ Features

- **Task Management** - Create, edit, delete tasks
- **Priority Levels** - Low, Medium, High priority tasks
- **Due Dates** - Set deadlines for tasks
- **Local Storage** - Data persists locally with Hive
- **Dark Theme** - Beautiful dark UI
- **Search & Filter** - Find tasks quickly

---

## 🛠️ Tech Stack

| Technology | Description |
|------------|------------|
| Flutter | UI Framework |
| Dart | Programming Language |
| Provider | State Management |
| Hive | Local Database |
| Google Fonts | Typography |

---

## 📱 Installation

### Prerequisites

- Flutter SDK 3.24+
- Android SDK 34
- Android Studio (optional)

### Clone & Build

```bash
# Clone the repo
git clone https://github.com/mohmaedeslam00116/ares.git
cd ares

# Install dependencies
flutter pub get

# Build debug APK
flutter build apk --debug

# Or run on device/emulator
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart              # App entry point
├── models/
│   └── task.dart         # Task model
├── providers/
│   └── task_provider.dart  # State management
├── screens/
│   ├── home_screen.dart    # Main screen
│   ├── add_task_screen.dart
│   └── edit_task_screen.dart
├── services/
│   └── storage_service.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    ├── task_card.dart
    ├── search_bar.dart
    ├── filter_chips.dart
    └── empty_state.dart
```

---

## 🚀 Releases

| Version | Date | Download |
|---------|------|----------|
| v1.0.0 | 2026-04-20 | [Download APK](https://github.com/mohmaedeslam00116/ares/releases/tag/v1.0.0) |

---

## 🤝 Contributing

1. Fork the repo
2. Create your branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Mohamed Eslam**
- GitHub: [@mohmaedeslam00116](https://github.com/mohmaedeslam00116)

---

## 🙏 Acknowledgments

- Flutter team for amazing framework
- Hive for local storage
- Google Fonts for beautiful typography

---

<p align="center">Made with ❤️ in Flutter</p>