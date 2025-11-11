import 'package:flutter/material.dart';
import '../../models/subject.dart';

class SubjectList extends StatelessWidget {
  final List<Subject> subjects;
  final void Function(String id) onDelete;

  const SubjectList({required this.subjects, required this.onDelete, super.key});

  Future<void> _confirmDelete(BuildContext context, Subject subject) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Subject'),
        content: Text('Are you sure you want to delete "${subject.name}"? This action cannot be undone.'),
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
      onDelete(subject.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) return const Center(child: Text('No subjects yet'));
    return ListView.builder(
      itemCount: subjects.length,
      itemBuilder: (c, i) {
        final s = subjects[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Color(int.parse(s.color.replaceFirst('#', '0xff')))),
            title: Text(s.name),
            subtitle: Text('${s.credits} credits'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, s),
            ),
          ),
        );
      },
    );
  }
}
