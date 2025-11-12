import 'package:flutter/material.dart';

class AssignmentItem extends StatelessWidget {
  final String title;
  const AssignmentItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('Due: —'),
      trailing: Checkbox(value: false, onChanged: (_) {}),
    );
  }
}
