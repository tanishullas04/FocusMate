import 'package:uuid/uuid.dart';

class Subject {
  final String id;
  String name;
  String color;
  int credits;

  Subject({
    String? id,
    required this.name,
    this.color = '#2196F3',
    this.credits = 0,
  }) : id = id ?? const Uuid().v4();

  factory Subject.fromJson(Map<String, dynamic> j) => Subject(
        id: j['id'] as String?,
        name: j['name'] as String? ?? '',
        color: j['color'] as String? ?? '#2196F3',
        credits: (j['credits'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'credits': credits,
      };
}
