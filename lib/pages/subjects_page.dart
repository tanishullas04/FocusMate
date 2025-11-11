import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/subjects/subject_list.dart';
import '../widgets/subjects/subject_form.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      drawer: _AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SubjectForm(onSave: (subject) async {
              await provider.addSubject(subject);
            }),
            const SizedBox(height: 16),
            Expanded(child: SubjectList(subjects: provider.state.subjects, onDelete: (id) => provider.deleteSubject(id))),
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
