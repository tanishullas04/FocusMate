import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';
import '../../models/assignment.dart';
import '../../services/utils.dart';

class UpcomingTasks extends StatelessWidget {
  final AppProvider provider;
  const UpcomingTasks({required this.provider, super.key});

  List<Assignment> _next7Days() {
    final now = DateTime.now();
    final end = now.add(const Duration(days: 7));
    return provider.state.assignments.where((a) => a.dueDate != null && a.dueDate!.isAfter(now) && a.dueDate!.isBefore(end)).toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }

  @override
  Widget build(BuildContext context) {
    final items = _next7Days();
    if (items.isEmpty) {
      return Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('No tasks due in the next 7 days.')));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((a) => ListTile(
        title: Text(a.title),
        subtitle: Text(a.dueDate != null ? formatDate(a.dueDate!) : 'No due date'),
        trailing: Checkbox(value: a.completed, onChanged: (_) => provider.toggleAssignmentComplete(a.id)),
      )).toList(),
    );
  }
}
