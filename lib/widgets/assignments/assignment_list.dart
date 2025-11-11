import 'package:flutter/material.dart';
import '../../models/assignment.dart';
import '../../services/utils.dart';

class AssignmentList extends StatelessWidget {
  final List<Assignment> assignments;
  final void Function(String id) onToggleComplete;
  final void Function(String id) onDelete;

  const AssignmentList({required this.assignments, required this.onToggleComplete, required this.onDelete, super.key});

  Future<void> _confirmDelete(BuildContext context, Assignment assignment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text('Are you sure you want to delete "${assignment.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      onDelete(assignment.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (assignments.isEmpty) return const Center(child: Text('No assignments'));
    return ListView.builder(
      itemCount: assignments.length,
      itemBuilder: (c, i) {
        final a = assignments[i];
        return Card(
          child: ListTile(
            title: Text(a.title),
            subtitle: Text(a.dueDate != null ? formatDate(a.dueDate!) : 'No due date'),
            leading: Checkbox(value: a.completed, onChanged: (_) => onToggleComplete(a.id)),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, a),
            ),
          ),
        );
      },
    );
  }
}
