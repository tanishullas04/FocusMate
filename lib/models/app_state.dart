import 'assignment.dart';
import 'subject.dart';
import 'user_settings.dart';

class AppState {
  List<Subject> subjects;
  List<Assignment> assignments;
  UserSettings settings;

  AppState({
    required this.subjects,
    required this.assignments,
    required this.settings,
  });

  factory AppState.empty() => AppState(
        subjects: [],
        assignments: [],
        settings: UserSettings(),
      );

  factory AppState.fromJson(Map<String, dynamic> j) {
    return AppState(
      subjects: (j['subjects'] as List<dynamic>? ?? []).map((e) => Subject.fromJson(Map<String, dynamic>.from(e))).toList(),
      assignments: (j['assignments'] as List<dynamic>? ?? []).map((e) => Assignment.fromJson(Map<String, dynamic>.from(e))).toList(),
      settings: j['settings'] != null ? UserSettings.fromJson(Map<String, dynamic>.from(j['settings'])) : UserSettings(),
    );
  }

  Map<String, dynamic> toJson() => {
        'subjects': subjects.map((s) => s.toJson()).toList(),
        'assignments': assignments.map((a) => a.toJson()).toList(),
        'settings': settings.toJson(),
      };
}
