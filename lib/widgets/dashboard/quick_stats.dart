import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';

class QuickStats extends StatelessWidget {
  final AppProvider provider;
  const QuickStats({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    final totalSubjects = provider.state.subjects.length;
    final totalAssignments = provider.state.assignments.length;
    final completed = provider.state.assignments.where((a) => a.completed).length;
    final completedPct = totalAssignments == 0 ? 0 : ((completed / totalAssignments) * 100).round();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatCard(label: 'Subjects', value: '$totalSubjects'),
        _StatCard(label: 'Assignments', value: '$totalAssignments'),
        _StatCard(label: 'Completed', value: '$completedPct%'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3.5,
        height: 80,
        child: Center(
          child: ListTile(
            title: Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(label, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
