import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final String name;
  const SubjectCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
