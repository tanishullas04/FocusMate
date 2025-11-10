import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/assignments/assignment_list.dart';
import '../widgets/assignments/assignment_form.dart';

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      drawer: _AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AssignmentForm(
              subjects: provider.state.subjects,
              onSave: (assignment) async {
                await provider.addAssignment(assignment);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AssignmentList(
                assignments: provider.state.assignments,
                onToggleComplete: (id) => provider.toggleAssignmentComplete(id),
                onDelete: (id) => provider.deleteAssignment(id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('FocusMate')),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            title: const Text('Subjects'),
            onTap: () => Navigator.pushReplacementNamed(context, '/subjects'),
          ),
          ListTile(
            title: const Text('Assignments'),
            onTap: () => Navigator.pushReplacementNamed(context, '/assignments'),
          ),
          ListTile(
            title: const Text('Calendar'),
            onTap: () => Navigator.pushReplacementNamed(context, '/calendar'),
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
          ),
        ],
      ),
    );
  }
}
