import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/subject.dart';
import '../models/assignment.dart';
import '../models/user_settings.dart';
import '../services/storage_service.dart';
import '../services/firebase_service.dart';

class AppProvider with ChangeNotifier {
  final FirebaseService? firebaseService;
  final StorageService storageService;

  AppState _state = AppState.empty();

  AppProvider({required this.storageService, this.firebaseService}) {
    load();
  }

  AppState get state => _state;

  Future<void> load() async {
    // Prefer Firebase if available
    if (firebaseService != null) {
      try {
        final subjects = await firebaseService!.getSubjects();
        final assignments = await firebaseService!.getAssignments();
        final settings = await firebaseService!.getSettings() ?? _state.settings;
        // Filter out any debug/default placeholder subjects that may be present
        final filteredSubjects = subjects.where((s) => !_isDebugOrPlaceholderSubject(s)).toList();
        _state = AppState(subjects: filteredSubjects, assignments: assignments, settings: settings);
        notifyListeners();
        return;
      } catch (e) {
        // Fallback to local storage if Firebase fails (offline, no auth, etc.)
        if (e.toString().contains('unavailable') || e.toString().contains('offline')) {
          print('Firebase unavailable - using local storage');
        } else {
          print('Firebase load failed: $e');
        }
      }
    }

    // local fallback
    final loaded = await storageService.loadState();
    // Remove any debug/default placeholders from local state as well
    loaded.subjects = loaded.subjects.where((s) => !_isDebugOrPlaceholderSubject(s)).toList();
    _state = loaded;
    notifyListeners();
  }

  bool _isDebugOrPlaceholderSubject(Subject s) {
    final n = s.name.trim().toLowerCase();
    if (n.isEmpty) return true;
    if (n == 'default' || n == 'debug') return true;
    if (n.contains('debug')) return true;
    return false;
  }

  Future<void> save() async {
    if (firebaseService != null) {
      try {
        // save subjects
        for (final s in _state.subjects) {
          await firebaseService!.addOrUpdateSubject(s);
        }
        // save assignments
        for (final a in _state.assignments) {
          await firebaseService!.addOrUpdateAssignment(a);
        }
        await firebaseService!.saveSettings(_state.settings);
      } catch (e, st) {
        // Log errors and stacktrace to help diagnose permission/auth/network issues
        print('AppProvider.save() failed: $e');
        print(st);
        rethrow;
      }
    } else {
      await storageService.saveState(_state);
    }
  }

    // Subject operations
  Future<void> addSubject(Subject s) async {
    _state.subjects.add(s);
    notifyListeners(); // Notify immediately so UI updates
    await save(); // Save in background
  }

  Future<void> updateSubject(Subject s) async {
    final idx = _state.subjects.indexWhere((x) => x.id == s.id);
    if (idx >= 0) {
      _state.subjects[idx] = s;
      notifyListeners(); // Notify immediately
      await save();
    }
  }

  Future<void> deleteSubject(String id) async {
    _state.subjects.removeWhere((s) => s.id == id);
    notifyListeners(); // Notify immediately
    // If using Firebase, delete from backend; otherwise persist locally
    if (firebaseService != null) {
      try {
        await firebaseService!.deleteSubject(id);
      } catch (e) {
        // If firebase delete fails, fallback to saving local state
        print('deleteSubject failed (firebase): $e');
        await save();
      }
    } else {
      await save();
    }
  }

  // Assignment operations
  Future<void> addAssignment(Assignment a) async {
    _state.assignments.add(a);
    notifyListeners(); // Notify immediately so UI updates
    await save(); // Save in background
  }

  Future<void> updateAssignment(Assignment a) async {
    final idx = _state.assignments.indexWhere((x) => x.id == a.id);
    if (idx >= 0) {
      _state.assignments[idx] = a;
      notifyListeners(); // Notify immediately
      await save();
    }
  }

  Future<void> deleteAssignment(String id) async {
    _state.assignments.removeWhere((a) => a.id == id);
    notifyListeners(); // Notify immediately
    // If using Firebase, delete from backend; otherwise persist locally
    if (firebaseService != null) {
      try {
        await firebaseService!.deleteAssignment(id);
      } catch (e) {
        // If firebase delete fails, fallback to saving local state
        print('deleteAssignment failed (firebase): $e');
        await save();
      }
    } else {
      await save();
    }
  }

  Future<void> toggleAssignmentComplete(String id) async {
    final idx = _state.assignments.indexWhere((x) => x.id == id);
    if (idx >= 0) {
      _state.assignments[idx].completed = !_state.assignments[idx].completed;
      notifyListeners(); // Notify immediately
      await save();
    }
  }

  // Settings
  Future<void> updateSettings(UserSettings s) async {
    _state.settings = s;
    notifyListeners(); // Notify immediately so theme updates
    await save();
  }

  Future<void> resetLocalState() async {
    _state = AppState.empty();
    await save();
    notifyListeners();
  }
}
