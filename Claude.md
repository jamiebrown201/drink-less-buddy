# Drink Less Buddy - Claude Development Guide

This file contains development workflows, commands, and best practices for working on the Drink Less Buddy Flutter app with Claude Code.

## 🧪 Testing Commands

### Run All Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run Specific Test Files
```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test test/integration/

# Specific test file
flutter test test/unit/models/drink_test.dart
```

### Watch Mode (Re-run on changes)
```bash
flutter test --watch
```

### Test Coverage Goals
- **Overall:** 70%+ coverage
- **Critical paths:** 90%+ (providers, repositories, core business logic)
- **UI widgets:** 60%+ (key screens and reusable widgets)

---

## 🔍 Code Quality

### Run Flutter Analyzer
```bash
flutter analyze
```

### Fix Auto-fixable Issues
```bash
dart fix --apply
```

### Format Code
```bash
dart format lib/ test/ -l 100
```

### Check for Unused Files
```bash
find lib -name "*.dart" ! -name "*_animated.dart" -type f | grep -v "utils\|constants\|models\|core"
```

---

## 🏗️ Build Commands

### Development Build (Debug)
```bash
# Android
flutter build apk --debug

# iOS
flutter build ios --debug
```

### Release Build
```bash
# Android (App Bundle for Play Store)
flutter build appbundle --release

# Android (APK)
flutter build apk --release --split-per-abi

# iOS
flutter build ios --release
```

### Build Size Analysis
```bash
flutter build apk --analyze-size
```

---

## 🔧 Development Workflows

### Start New Feature
```bash
# 1. Create new branch
git checkout -b feature/feature-name

# 2. Run tests to ensure starting point is clean
flutter test

# 3. Begin development...
```

### Pre-Commit Checklist
```bash
# 1. Format code
dart format lib/ test/ -l 100

# 2. Run analyzer
flutter analyze

# 3. Run tests
flutter test

# 4. Check coverage (optional but recommended)
flutter test --coverage

# 5. If all pass, commit
git add .
git commit -m "feat: your commit message"
```

### Code Review Preparation
```bash
# Generate test coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Run full analysis
flutter analyze > analysis_report.txt

# Check for TODOs
grep -r "TODO\|FIXME" lib/ test/
```

---

## 🐛 Debugging

### Run with Device Logs
```bash
flutter run -v
```

### Debug Specific Platform
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Chrome (web)
flutter run -d chrome
```

### Clear Build Cache
```bash
flutter clean
flutter pub get
```

### Fix Gradle Issues (Android)
```bash
cd android
./gradlew clean
cd ..
flutter pub get
```

---

## 📦 Dependencies

### Update Dependencies
```bash
flutter pub upgrade
```

### Get Dependencies
```bash
flutter pub get
```

### Check for Outdated Packages
```bash
flutter pub outdated
```

### Add New Package
```bash
flutter pub add package_name
```

### Add Dev Dependency
```bash
flutter pub add -d package_name
```

---

## 📊 Performance & Profiling

### Profile App Performance
```bash
flutter run --profile
```

### Build Performance Report
```bash
flutter build apk --profile --analyze-size
```

### Check Widget Rebuild Performance
```bash
flutter run --trace-skia
```

---

## 🎨 Assets & Icons

### Generate App Icons (after updating icon)
```bash
flutter pub run flutter_launcher_icons:main
```

### Generate Splash Screens
```bash
flutter pub run flutter_native_splash:create
```

---

## 📝 Documentation

### Generate Dart Documentation
```bash
dart doc .
open doc/api/index.html
```

### Update Architecture Diagrams
```bash
# After major changes, update:
# - ARCHITECTURE.md
# - README.md diagrams
# - Design system documentation
```

---

## 🔐 Security

### Check for Security Vulnerabilities
```bash
flutter pub outdated --mode=null-safety
```

### Validate Dependency Licenses
```bash
flutter pub licenses
```

---

## 🚀 Deployment

### Pre-Deployment Checklist

#### Android
- [ ] Update version in `pubspec.yaml`
- [ ] Update `android/app/build.gradle` version codes
- [ ] Test on multiple Android versions (8+)
- [ ] Run release build and test
- [ ] Generate signed bundle
- [ ] Test installation from bundle

#### iOS
- [ ] Update version in `pubspec.yaml`
- [ ] Update `ios/Runner.xcodeproj` version
- [ ] Test on multiple iOS versions (12+)
- [ ] Run release build and test
- [ ] Test on physical device
- [ ] Submit to TestFlight

### Version Bump
```bash
# Example: 1.0.0+1 -> 1.0.1+2
# pubspec.yaml: version: 1.0.1+2
```

---

## 🧹 Maintenance

### Weekly Tasks
- [ ] Run `flutter pub upgrade`
- [ ] Review and address analyzer warnings
- [ ] Check test coverage trends
- [ ] Review TODOs and FIXMEs

### Monthly Tasks
- [ ] Dependency audit
- [ ] Performance profiling
- [ ] Security updates
- [ ] Documentation review

---

## 🎯 Architecture Patterns

### When Adding New Features

1. **Models First** - Define data models in `lib/models/`
2. **Repository Layer** - Create repository interface and implementation
3. **Provider/State** - Add state management in `lib/providers/`
4. **UI Layer** - Create animated screens in `lib/screens/`
5. **Tests** - Write tests for each layer (TDD preferred)

### File Naming Conventions
- Screens: `*_screen_animated.dart`
- Widgets: `*.dart` (descriptive names)
- Providers: `*_provider_refactored.dart`
- Repositories: `*_repository.dart`
- Models: `*.dart` (singular, e.g., `drink.dart`)
- Tests: `*_test.dart`

---

## 💡 Quick Tips

### Speed Up Development
```bash
# Hot reload: r (in terminal during flutter run)
# Hot restart: R
# Clear console: c
# Quit: q
```

### Common Issues & Solutions

**Issue:** "Target file doesn't exist"
```bash
flutter clean && flutter pub get
```

**Issue:** Gradle build fails
```bash
cd android && ./gradlew clean && cd ..
flutter pub get
```

**Issue:** iOS build fails
```bash
cd ios && pod deinstall && pod install && cd ..
flutter clean && flutter pub get
```

**Issue:** Tests fail with dependency errors
```bash
flutter pub get
flutter test --no-pub
```

---

## 📋 Commit Message Format

Use conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting)
- `refactor:` - Code refactoring
- `test:` - Adding/updating tests
- `chore:` - Maintenance tasks

Example:
```bash
git commit -m "feat: add intention setting screen with haptic feedback"
git commit -m "test: add unit tests for DrinkProvider"
git commit -m "fix: resolve navigation issue in onboarding flow"
```

---

## 🤝 Working with Claude Code

### Asking for Help

**Good Prompts:**
- "Add unit tests for the DrinkProvider"
- "Refactor this widget to use the new design system"
- "Find and fix all TODOs in the analytics module"
- "Create a widget test for the login screen"

**Specific Requests:**
- "Run the test suite and fix any failures"
- "Check code coverage and identify untested areas"
- "Update all dependencies and fix breaking changes"

### Before Starting Work
1. Review this Claude.md file
2. Check current test coverage: `flutter test --coverage`
3. Run analyzer: `flutter analyze`
4. Review recent commits: `git log --oneline -10`

---

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Provider Package](https://pub.dev/packages/provider)
- [Testing Flutter Apps](https://docs.flutter.dev/testing)
- [App Architecture](./ARCHITECTURE.md)
- [Design System](./UI_UX_DESIGN.md)
- [Research References](./RESEARCH.md)

---

**Last Updated:** 2025-12-28
**Flutter Version:** 3.0+
**Dart Version:** 3.0+
