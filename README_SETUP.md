# FocusMate - Student Assignment Tracker

A Flutter app for managing subjects, assignments, and deadlines with local storage and optional Firebase sync.

## Features

- ✅ Subjects management (name, color, credits)
- ✅ Assignments with due dates, priority, and completion tracking
- ✅ Dashboard with quick stats and upcoming tasks
- ✅ Calendar week view
- ✅ Settings (theme, default reminder times)
- ✅ Export/import data (JSON)
- ✅ Local-first storage (SharedPreferences)
- ✅ Optional Firebase sync (Firestore)

## Project Structure

```
lib/
  main.dart              # App entry point with Firebase/Provider setup
  app.dart               # MaterialApp with routes and theme
  routes.dart            # Route name constants
  models/                # Data models (Subject, Assignment, UserSettings, AppState)
  services/              # Storage, Firebase, Export services
  providers/             # AppProvider (state management with ChangeNotifier)
  pages/                 # Dashboard, Subjects, Assignments, Calendar, Profile
  widgets/               # Reusable UI components organized by feature
  utils/                 # Date formatting helpers
test/                    # Unit and widget tests
```

## Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run the App (Local Storage Only)

The app works out of the box with local storage (SharedPreferences):

```bash
flutter run
```

### 3. Optional: Enable Firebase

If you want cloud sync:

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Configure FlutterFire: `flutterfire configure`
4. Uncomment Firebase options import in `lib/main.dart`:
   ```dart
   import 'firebase_options.dart';
   // and
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   ```

## State Management

Uses Provider with `AppProvider` (ChangeNotifier):
- Load/save state from local storage or Firebase
- CRUD operations for subjects and assignments
- Settings persistence (theme, reminders)

## Storage Options

1. **Local Storage** (default): Uses SharedPreferences to persist state as JSON
2. **Firebase**: Optional Firestore sync when Firebase is configured

The app automatically falls back to local storage if Firebase init fails.

## Development

### Run Tests

```bash
flutter test
```

### Analyze Code

```bash
flutter analyze
```

### Format Code

```bash
flutter format lib/
```

## Building

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## Next Steps

- Implement notifications/reminders (using flutter_local_notifications)
- Add more calendar views (month, day)
- Enhance export/import with file picker
- Add authentication (Firebase Auth)
- Improve UI/UX with animations and themes
- Add search and filtering for assignments

## License

MIT
