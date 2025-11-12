import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';

class DeadlineCard extends StatelessWidget {
  final AppProvider provider;
  const DeadlineCard({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    final urgent = provider.state.assignments.where((a) {
      if (a.dueDate == null) return false;
      final diff = a.dueDate!.difference(DateTime.now());
      return diff.inHours <= 48 && !a.completed;
    }).toList();

    if (urgent.isEmpty) return const SizedBox.shrink();

    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: urgent.map((a) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold))),
              Text('${a.dueDate?.toLocal()}'),
            ],
          )).toList(),
        ),
      ),
    );
  }
}
