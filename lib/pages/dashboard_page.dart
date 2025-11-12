import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/dashboard/quick_stats.dart';
import '../widgets/dashboard/upcoming_tasks.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('FocusMate - Dashboard')),
      drawer: _AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => provider.load(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuickStats(provider: provider),
              const SizedBox(height: 16),
              UpcomingTasks(provider: provider),
            ],
          ),
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
