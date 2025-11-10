import 'package:uuid/uuid.dart';

class Assignment {
  final String id;
  String title;
  String? subjectId;
  DateTime? dueDate;
  String priority; // low, medium, high
  String description;
  bool completed;
  int? reminderMinutesBefore; // nullable

  Assignment({
    String? id,
    required this.title,
    this.subjectId,
    this.dueDate,
    this.priority = 'medium',
    this.description = '',
    this.completed = false,
    this.reminderMinutesBefore,
  }) : id = id ?? const Uuid().v4();

  factory Assignment.fromJson(Map<String, dynamic> j) => Assignment(
        id: j['id'] as String?,
        title: j['title'] ?? '',
        subjectId: j['subjectId'],
        dueDate: j['dueDate'] != null ? DateTime.parse(j['dueDate']) : null,
        priority: j['priority'] ?? 'medium',
        description: j['description'] ?? '',
        completed: j['completed'] ?? false,
        reminderMinutesBefore: j['reminderMinutesBefore'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subjectId': subjectId,
        'dueDate': dueDate?.toIso8601String(),
        'priority': priority,
        'description': description,
        'completed': completed,
        'reminderMinutesBefore': reminderMinutesBefore,
      };
}
